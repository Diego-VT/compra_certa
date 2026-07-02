# Sprint 07 - Lista de Compras

## Objetivo

Permitir criar, editar e acompanhar listas de compras offline.

## Escopo

- Tabela `listas_compras`.
- Tabela `itens_lista_compras`.
- Adicionar produtos a lista.
- Marcar itens comprados.
- Gerar lista a partir de estoque baixo.

## Fora do Escopo

- Compartilhamento em tempo real.
- Sincronizacao.
- IA externa.

## Regras de Negocio

- Lista deve funcionar offline.
- Item comprado nao deve ser removido automaticamente.
- Usuario deve revisar sugestoes antes de salvar.

## Arquitetura Envolvida

Nova feature `listas_compras`.

## Modulos Envolvidos

- `features/listas_compras`
- `features/produtos`
- `features/estoque`

## Tabelas Afetadas

- Futuras: `listas_compras`, `itens_lista_compras`.

## Providers

- Providers de listas.

## Repositories

- `ListaCompraRepository`.

## Usecases

- Criar lista.
- Adicionar item.
- Marcar item comprado.
- Gerar lista por estoque baixo.

## Telas Previstas

- Listas abertas.
- Detalhe da lista.
- Selecao de produtos.

## Testes Necessarios

- Criacao de lista.
- Marcacao de item.
- Geracao por estoque baixo.

## Criterios de Aceite

- Fluxo offline.
- UI simples e responsiva.
- Testes principais passando.

## Riscos

- Duplicidade de itens.
- Lista grande sem carregamento incremental.

## Checklist de Conclusao

- Regras documentadas.
- Testes criados.
- Roadmap atualizado.
