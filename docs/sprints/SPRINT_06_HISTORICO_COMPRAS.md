# Sprint 06 - Historico de Compras

## Objetivo

Registrar compras realizadas e permitir consulta por periodo.

## Escopo

- Tabela `compras`.
- Tabela `itens_compra`.
- Listagem incremental de historico.
- Filtro por periodo.

## Fora do Escopo

- Relatorios avancados.
- IA.
- Sincronizacao.

## Regras de Negocio

- Compra deve ter data.
- Item deve referenciar produto.
- Historico deve ser consultado de forma otimizada.

## Arquitetura Envolvida

Nova feature `compras` com datasource local, repository, usecases e providers.

## Modulos Envolvidos

- `features/compras`
- `features/produtos`
- `features/estoque`

## Tabelas Afetadas

- Futuras: `compras`, `itens_compra`.
- Relacionadas: `produtos`.

## Providers

- Providers de compras.

## Repositories

- `CompraRepository`.

## Usecases

- Registrar compra.
- Listar compras por periodo.
- Obter detalhes da compra.

## Telas Previstas

- Lista de compras realizadas.
- Detalhe da compra.

## Testes Necessarios

- Criacao de compra.
- Insercao de itens.
- Filtro por periodo.
- Consulta paginada ou incremental.

## Criterios de Aceite

- Historico funciona offline.
- Consultas nao travam a UI.
- Testes passam.

## Riscos

- Volume alto de historico.
- Relacionamento incorreto entre compra e itens.

## Checklist de Conclusao

- Banco documentado.
- Testes adicionados.
- Changelog atualizado.
- Filtro por periodo implementado na UI.
- Carregamento incremental implementado na UI.
- Paginacao estabilizada por data e id.
- Indices de historico adicionados.
- `flutter analyze` executado com sucesso.
- `flutter test` executado com sucesso.
