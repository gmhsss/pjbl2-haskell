# Decisões de modelagem e limitações

- **Tipos algébricos e records:** `Resultado` restringe os resultados a vitória, empate e derrota. `Partida` e `Linha` nomeiam seus campos e reduzem o risco de confusão entre gols pró e contra.
- **Critérios de desempate:** pontos, vitórias, saldo de gols, gols pró e nome em ordem alfabética, nessa prioridade. A ordenação usa `sortBy`, `comparing`, `Down` e composição de comparadores com `<>`.
- **Funções de ordem superior:** `foldl'` acumula os dados de cada time sem recursão explícita. `map` constrói linhas, `filter` seleciona partidas e `(.)` compõe consultas.
- **Robustez:** `readMaybe` evita exceções de conversão. `Either Erro` informa o problema e `traverse` para no primeiro erro sintático; `todosOsErros` registra todas as falhas de conversão e duplicações entre partidas válidas.
- **Lista vazia:** `maiorGoleada` e `mediaGols` retornam `Nothing`, e a classificação vazia é `[]`.
- **Limitações:** nomes são comparados exatamente após remover espaços nas bordas (maiúsculas e acentos continuam relevantes); resultados não são cruzados com uma tabela oficial; empates em diferença máxima de gols escolhem uma das partidas empatadas; em `todosOsErros`, não são investigadas duplicações envolvendo linhas que já falharam na conversão; não são verificados calendários completos ou um número máximo de jogos por time no campeonato.
