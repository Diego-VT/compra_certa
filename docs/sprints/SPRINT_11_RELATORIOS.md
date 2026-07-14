# Sprint 11 - Relatorios

## Status

Concluida em 2026-07-14. Sprint finalizada com feature `relatorios`, tela inicial, filtros rapidos por periodo, consultas agregadas no banco, testes automatizados, revisao tecnica e documentacao atualizada.

## Objetivo

Permitir analise de compras, produtos e consumo por periodo.

## Escopo

- Relatorio por categoria.
- Produtos mais comprados.
- Consumo por periodo.
- Preparacao para exportacao futura.

## Fora do Escopo

- BI avancado.
- Graficos pesados.
- Exportacao obrigatoria.

## Regras de Negocio

- Relatorios devem carregar sob demanda.
- Consultas devem ser agregadas no banco quando possivel.

## Arquitetura Envolvida

Feature `relatorios` consumindo dados de compras e produtos.

## Modulos Envolvidos

- `features/relatorios`
- `features/compras`
- `features/produtos`

## Tabelas Afetadas

- Leitura de compras, itens e produtos.

## Providers

- Providers de relatorios.

## Repositories

- Repository de relatorios ou consultas agregadas por modulo.

## Usecases

- Relatorio por categoria.
- Relatorio de consumo por periodo.
- Produtos mais recorrentes.

## Telas Previstas

- Tela de relatorios.
- Filtros por periodo.

## Testes Necessarios

- Agregacoes.
- Filtros.
- Estados vazios.

## Criterios de Aceite

- Relatorios corretos.
- Carregamento sob demanda.
- Testes passando.

## Riscos

- Lentidao em historico grande.
- Consultas duplicadas.

## Checklist de Conclusao

- [x] Feature `relatorios` iniciada.
- [x] Consulta agregada de resumo por periodo criada.
- [x] Consulta de produtos mais comprados criada.
- [x] Consulta de consumo por categoria criada.
- [x] Tela de relatorios criada.
- [x] Filtros rapidos por periodo criados.
- [x] Atalho no dashboard criado.
- [x] Testes iniciais de agregacao criados.
- [x] Testes iniciais de tela e estado vazio criados.
- [x] Revisao final da sprint.
- [x] Teste de navegacao pelo dashboard criado.
- [x] `flutter analyze` executado no encerramento.
- [x] `flutter test` executado no encerramento.
