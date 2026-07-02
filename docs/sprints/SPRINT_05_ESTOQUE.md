# Sprint 05 - Estoque

## Status

Validada tecnicamente, commit local criado e push pendente por verificacao SSH do GitHub.

## Objetivo

Controlar a quantidade atual dos produtos e identificar itens abaixo do minimo.

## Escopo

- Tabela de estoque.
- Tabela de movimentacoes.
- Entrada, saida e ajuste.
- Indicador de estoque baixo.
- Filtro visual para produtos abaixo do minimo.

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

- Criadas: `estoques`, `movimentacoes_estoque`.
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
- Produtos abaixo do minimo filtrados diretamente no banco.
- Fluxo offline.
- `flutter analyze` e `flutter test` OK.

## Riscos

- Modelagem insuficiente para historico.
- Consultas lentas sem indice.

## Checklist de Conclusao

- [x] Migration criada.
- [x] Testes criados.
- [x] Consulta otimizada para produtos abaixo do minimo.
- [x] Filtro visual de estoque baixo criado.
- [x] Modelo de dados atualizado.
- [x] Release notes atualizadas.
- [x] `flutter analyze` executado.
- [x] `flutter test` executado.
- [x] Revisao tecnica realizada.
- [x] Relatorio final preparado.
- [x] Aprovacao do usuario para commit e push.
- [x] Commit local criado.
- [x] Push autorizado.
- [ ] Push concluido.

## Resultado da Revisao

- Clean Architecture preservada.
- Repository Pattern preservado.
- Riverpod usado para injecao de dependencia e estado assincromo.
- Go Router atualizado para rotas de estoque.
- Drift/SQLite atualizado para schema `3`.
- Consulta de produtos abaixo do minimo filtrada diretamente no banco.
- Funcionalidades principais permanecem offline.

## Pendencias Acompanhadas

- Avaliar indices adicionais para `movimentacoes_estoque` quando consultas de historico, dashboard ou relatorios forem implementadas.
- Ampliar testes de widget da tela de estoque quando o fluxo visual se estabilizar.
