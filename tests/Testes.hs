module Main (main) where

import Classificacao
import Dados
import Leitura
import Tipos

verificar :: (Eq a, Show a) => String -> a -> a -> IO ()
verificar nome obtido esperado =
  if obtido == esperado
    then putStrLn ("OK - " ++ nome)
    else error ("FALHOU - " ++ nome ++ " (obtido: " ++ show obtido ++ "; esperado: " ++ show esperado ++ ")")

partidas :: [Partida]
partidas = case lerCampeonato dadosCampeonato of
  Right ps -> ps
  Left e -> error ("Dados de teste invalidos: " ++ show e)

primeira :: Partida
primeira = Partida 1 "Coritiba" 2 0 "Londrina"

main :: IO ()
main = do
  verificar "mandante" (resultadoPara "Coritiba" primeira) (Just Vitoria)
  verificar "visitante" (resultadoPara "Londrina" primeira) (Just Derrota)
  verificar "ausente" (resultadoPara "Parana" primeira) Nothing
  verificar "times ordenados" (times partidas)
    ["Athletico", "Coritiba", "Londrina", "Maringa", "Operario", "Parana"]
  verificar "15 partidas" (length partidas) 15
  verificar "classificacao final" (map (\l -> (nomeTime l, pontosLinha l)) (classificacao partidas))
    [("Athletico",9),("Operario",9),("Coritiba",8),("Parana",5),("Maringa",5),("Londrina",2)]
  verificar "desempate por saldo (Athletico antes do Operario)"
    (map nomeTime (take 2 (classificacao partidas))) ["Athletico", "Operario"]
  verificar "desempate por saldo (Parana antes do Maringa)"
    (map nomeTime (drop 3 (take 5 (classificacao partidas)))) ["Parana", "Maringa"]
  verificar "ate rodada 3, classificacao diferente"
    (map nomeTime (classificacao (ateRodada 3 partidas)) /= map nomeTime (classificacao partidas)) True
  verificar "ate rodada 3, nove partidas" (length (ateRodada 3 partidas)) 9
  verificar "maior goleada vazia" (maiorGoleada []) Nothing
  verificar "media vazia" (mediaGols []) Nothing
  verificar "campeonato vazio" (classificacao []) []
  verificar "aproveitamento sem jogos" (aproveitamento (linhaDoTime [] "X")) 0
  verificar "ler entrada valida" (lerCampeonato dadosCampeonato) (Right partidas)
  verificar "campos invalidos" (lerPartida 8 "1;X;2") (Left (CamposInvalidos 8))
  verificar "numero invalido" (lerPartida 9 "1;X;dois;0;Y") (Left (NumeroInvalido 9 "dois"))
  verificar "placar negativo" (lerPartida 10 "1;X;-1;0;Y") (Left (PlacarNegativo 10))
  verificar "mesmo time" (lerPartida 11 "1;X;1;0;X") (Left (MesmoTime 11))
  verificar "time repetido" (lerCampeonato "1;X;1;0;Y\n1;Y;0;0;Z")
    (Left (TimeRepetidoNaRodada 2 "Y"))
  verificar "todos os erros" (todosOsErros dadosInvalidos)
    [ NumeroInvalido 1 "dois", PlacarNegativo 2, MesmoTime 3
    , TimeRepetidoNaRodada 5 "Operario" ]
  verificar "ignorar comentarios e linhas vazias"
    (lerCampeonato "\n # comentario\n1;X;0;0;Y\n") (Right [Partida 1 "X" 0 0 "Y"])
  putStrLn "Todos os testes passaram."
