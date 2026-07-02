# Sprint 11 - Relatorios

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

- Consultas revisadas.
- Testes criados.
- Documentacao atualizada.
