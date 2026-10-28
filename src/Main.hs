module Main (main) where

import Classificacao
import Dados
import Leitura
import Tipos (Partida)

mostrarEstatisticas :: [Partida] -> IO ()
mostrarEstatisticas ps = do
  putStrLn "\nEstatisticas:"
  putStrLn ("Maior goleada: " ++ show (maiorGoleada ps))
  putStrLn ("Media de gols: " ++ show (mediaGols ps))

main :: IO ()
main = do
  putStrLn "=== Campeonato: classificacao final ==="
  case lerCampeonato dadosCampeonato of
    Left erro -> putStrLn ("Erro na entrada: " ++ show erro)
    Right partidas -> do
      putStr (tabelaFormatada (classificacao partidas))
      putStrLn "\n=== Classificacao ate a rodada 3 ==="
      putStr (tabelaFormatada (classificacao (ateRodada 3 partidas)))
      mostrarEstatisticas partidas
  putStrLn "\n=== Exemplo de entrada invalida ==="
  putStrLn ("Primeiro erro: " ++ show (lerCampeonato dadosInvalidos))
  putStrLn "Todos os erros:"
  mapM_ print (todosOsErros dadosInvalidos)
