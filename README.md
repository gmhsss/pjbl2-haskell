# PjBL2 — Tabela de Classificação de Campeonato (Haskell)

Projeto de Programação Lógica e Funcional: três camadas para modelagem, cálculo de classificação e leitura/validação de partidas. Dados fictícios de seis equipes e cinco rodadas.

## Ambiente

GHC local (biblioteca padrão `base`). Não há dependências externas nem leitura por teclado. Também é possível adaptar para o playground unindo os módulos.

## Executar

Na raiz do repositório:

```bash
ghc -Wall -isrc -outputdir /tmp/pjbl2-build -o /tmp/pjbl2-app src/Main.hs
/tmp/pjbl2-app
```

Crie o diretório de build antes se ele não existir: `mkdir -p /tmp/pjbl2-build`.

Para executar sem gerar executável:

```bash
runghc -isrc src/Main.hs
```

## Testes

```bash
runghc -isrc tests/Testes.hs
```

Os testes cobrem as três camadas, critérios de desempate, entradas incorretas e casos vazios. Uma falha faz o processo terminar com erro.

## Estrutura

- `src/Tipos.hs`: tipos e consultas básicas.
- `src/Classificacao.hs`: classificação, estatísticas e filtros.
- `src/Leitura.hs`: leitura de texto, validação e impressão.
- `src/Dados.hs`: campeonato e entradas inválidas de exemplo.
- `src/Main.hs`: demonstração das três camadas.
- `tests/Testes.hs`: testes automatizados sem bibliotecas externas.
- `docs/decisoes.md`: justificativas e limitações.

## Dados de demonstração

Seis times, 15 jogos, cinco rodadas, um empate em 0x0 e goleadas de três gols. Athletico e Operario terminam empatados em 9 pontos; o primeiro fica à frente pelo saldo de gols. Parana e Maringa empatam em 5 pontos; Parana fica à frente pelo saldo de gols.

## Entrega

Publique esta pasta em um repositório GitHub acessível para o professor e envie a URL do repositório no Canvas.
