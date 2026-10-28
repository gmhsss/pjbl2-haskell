module Leitura
  ( Erro(..), separar, lerPartida, lerCampeonato, todosOsErros
  , tabelaFormatada
  ) where

import Data.Char (isSpace)
import Data.List (foldl', intercalate)
import Text.Read (readMaybe)
import Classificacao (pontosLinha, saldo)
import Tipos

data Erro
  = CamposInvalidos Int
  | NumeroInvalido Int String
  | PlacarNegativo Int
  | MesmoTime Int
  | TimeRepetidoNaRodada Int Time
  deriving (Eq, Show)

separar :: Char -> String -> [String]
separar c = foldr passo [""]
  where
    passo x acc@(inicio:resto)
      | x == c = "" : acc
      | otherwise = (x : inicio) : resto
    passo _ [] = []

limpar :: String -> String
limpar = dropWhileEndSpace . dropWhile isSpace
  where
    dropWhileEndSpace = reverse . dropWhile isSpace . reverse

lerPartida :: Int -> String -> Either Erro Partida
lerPartida numero texto =
  case map limpar (separar ';' texto) of
    [r, casa, gm, gv, fora]
      | null casa || null fora -> Left (CamposInvalidos numero)
      | otherwise -> do
          numRodada <- inteiro r
          golsCasa <- inteiro gm
          golsFora <- inteiro gv
          if numRodada <= 0 then Left (NumeroInvalido numero r)
          else if golsCasa < 0 || golsFora < 0 then Left (PlacarNegativo numero)
          else if casa == fora then Left (MesmoTime numero)
          else Right (Partida numRodada casa golsCasa golsFora fora)
    _ -> Left (CamposInvalidos numero)
  where
    inteiro s = maybe (Left (NumeroInvalido numero s)) Right (readMaybe s :: Maybe Int)

-- Mantém os números originais das linhas, mesmo após ignorar comentários.
linhasUteis :: String -> [(Int, String)]
linhasUteis = filter (\(_, s) -> not (null s) && take 1 s /= "#")
           . map (\(i, s) -> (i, limpar s)) . zip [1..] . lines

-- Confere duplicações a partir das partidas válidas já encontradas.
errosDuplicacao :: [(Int, Partida)] -> [Erro]
errosDuplicacao = reverse . terceira . foldl' passo ([], [])
  where
    terceira (_, x) = x
    passo (vistos, erros) (linha, p) =
      let ts = [mandante p, visitante p]
          novos = [(rodada p, t) | t <- ts]
          duplicados = [TimeRepetidoNaRodada linha t | t <- ts, (rodada p, t) `elem` vistos]
      in (vistos ++ novos, reverse duplicados ++ erros)

-- traverse interrompe no primeiro erro de conversão.
lerCampeonato :: String -> Either Erro [Partida]
lerCampeonato entrada = do
  pares <- traverse (\(n, s) -> (,) n <$> lerPartida n s) (linhasUteis entrada)
  case errosDuplicacao pares of
    erro : _ -> Left erro
    [] -> Right (map snd pares)

-- Reúne erros de formato e duplicações, sem lançar exceção.
todosOsErros :: String -> [Erro]
todosOsErros entrada = errosDeLeitura ++ errosDuplicacao partidasValidas
  where
    resultados = map (\(n, s) -> (n, lerPartida n s)) (linhasUteis entrada)
    errosDeLeitura = [e | (_, Left e) <- resultados]
    partidasValidas = [(n, p) | (n, Right p) <- resultados]

tabelaFormatada :: [Linha] -> String
tabelaFormatada ls = unlines (cabecalho : zipWith formatar [1 :: Int ..] ls)
  where
    cabecalho = "POS | TIME            | PTS | J | V | E | D | SG"
    formatar pos l = intercalate " | "
      [ ajusta 3 (show pos), ajusta 15 (nomeTime l)
      , ajusta 3 (show (pontosLinha l)), show (jogos l)
      , show (vitorias l), show (empates l), show (derrotas l)
      , show (saldo l) ]
    ajusta n s = take n (s ++ replicate n ' ')
