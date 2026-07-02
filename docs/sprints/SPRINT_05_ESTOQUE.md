# Sprint 05 - Estoque

## Objetivo

Controlar a quantidade atual dos produtos e identificar itens abaixo do minimo.

## Escopo

- Tabela de estoque.
- Tabela de movimentacoes.
- Entrada, saida e ajuste.
- Indicador de estoque baixo.

## Fora do Escopo

- Lista de compras.
- Historico completo de compras.
- IA.

## Regras de Negocio

- Quantidade atual nao pode ser negativa.
- Produto inativo nao deve receber movimentacao operacional sem confirmacao.
- Estoque baixo ocorre quando quantidade atual for menor que quantidade minima.

## Arquitetura Envolvida

Nova feature `estoque` seguindo Clean Architecture.

## Modulos Envolvidos

- `features/estoque`
- `features/produtos`

## Tabelas Afetadas

- Futuras: `estoque`, `movimentacoes_estoque`.
- Leitura: `produtos`.

## Providers

- Providers de estoque.
- Providers de produtos para apoio.

## Repositories

- `EstoqueRepository`.

## Usecases

- Obter estoque por produto.
- Registrar movimentacao.
- Listar produtos abaixo do minimo.

## Telas Previstas

- Resumo de estoque.
- Ajuste de estoque por produto.

## Testes Necessarios

- Entrada de estoque.
- Saida de estoque.
- Ajuste de estoque.
- Regra de estoque baixo.

## Criterios de Aceite

- Banco migrado com seguranca.
- Consultas otimizadas.
- Fluxo offline.
- `flutter analyze` e `flutter test` OK.

## Riscos

- Modelagem insuficiente para historico.
- Consultas lentas sem indice.

## Checklist de Conclusao

- Migration criada.
- Testes criados.
- Modelo de dados atualizado.
- Release notes atualizadas.
