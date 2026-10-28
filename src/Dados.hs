module Dados (dadosCampeonato, dadosInvalidos) where

dadosCampeonato :: String
dadosCampeonato = unlines
  [ "# rodada;mandante;gols mandante;gols visitante;visitante"
  , "1;Coritiba;2;0;Londrina"
  , "1;Athletico;1;1;Operario"
  , "1;Parana;0;0;Maringa"
  , "2;Coritiba;0;1;Operario"
  , "2;Londrina;0;3;Maringa"
  , "2;Athletico;2;1;Parana"
  , "3;Coritiba;3;0;Maringa"
  , "3;Operario;1;0;Parana"
  , "3;Londrina;2;2;Athletico"
  , "4;Coritiba;1;1;Parana"
  , "4;Maringa;0;2;Athletico"
  , "4;Operario;0;0;Londrina"
  , "5;Coritiba;2;2;Athletico"
  , "5;Parana;1;0;Londrina"
  , "5;Maringa;1;1;Operario"
  ]

dadosInvalidos :: String
dadosInvalidos = unlines
  [ "1;Coritiba;dois;0;Athletico"
  , "2;Parana;-1;2;Londrina"
  , "3;Maringa;1;0;Maringa"
  , "4;Coritiba;1;1;Operario"
  , "4;Operario;0;0;Londrina"
  ]
