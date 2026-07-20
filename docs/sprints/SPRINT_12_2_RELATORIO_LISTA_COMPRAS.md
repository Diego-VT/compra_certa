# Sprint 12.2 - Relatorio da Lista de Compras

## Status

Concluida em 2026-07-20.

## Objetivo

Permitir visualizar e compartilhar um relatorio individual da lista de compras.

## Escopo

- Resumo da lista, status, datas e percentual de conclusao.
- Itens planejados, comprados e pendentes.
- Quantidades planejadas e compradas.
- Pre-visualizacao no aplicativo.
- Geracao e compartilhamento de PDF offline.

## Fora do Escopo

- Relatorio comparativo entre listas.
- Graficos avancados.
- Armazenamento permanente de arquivos.
- Sincronizacao em nuvem.

## Arquitetura

- Entidades e use case na feature `listas_compras`.
- Gerador de PDF isolado por contrato.
- Reutilizacao das tabelas e repositories atuais, sem migration.

## Criterios de Aceite

- Relatorio disponivel no detalhe da lista.
- Lista aberta ou concluida pode ser visualizada.
- Lista vazia tem estado orientativo.
- PDF pode ser compartilhado.
- `flutter analyze` e `flutter test` sem falhas.

## Checklist de Conclusao

- [x] US-021 e backlog atualizados.
- [x] Entidades e use case criados.
- [x] Resumo e progresso implementados.
- [x] Pre-visualizacao adicionada ao aplicativo.
- [x] PDF multipagina gerado localmente.
- [x] Compartilhamento integrado.
- [x] Lista vazia tratada.
- [x] Testes de dominio, PDF e interface adicionados.
- [x] `flutter analyze` sem problemas.
- [x] `flutter test` com toda a suite aprovada.
