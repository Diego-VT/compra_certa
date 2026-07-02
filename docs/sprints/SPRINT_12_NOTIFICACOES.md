# Sprint 12 - Notificacoes

## Objetivo

Alertar usuario sobre reposicao, estoque baixo e listas pendentes.

## Escopo

- Notificacoes locais.
- Preferencias do usuario.
- Eventos de estoque baixo.

## Fora do Escopo

- Push remoto.
- Sincronizacao.
- Campanhas de marketing.

## Regras de Negocio

- Usuario deve controlar preferencias.
- Notificacoes devem respeitar contexto local.
- App deve funcionar sem internet.

## Arquitetura Envolvida

Service de notificacoes isolado em `services/` e usecases de negocio.

## Modulos Envolvidos

- `services/notificacoes`
- `features/estoque`
- `features/listas_compras`

## Tabelas Afetadas

- Futuras preferencias de notificacao, se necessario.

## Providers

- Provider de notificacoes.
- Provider de preferencias.

## Repositories

- Repository de preferencias, se houver persistencia.

## Usecases

- Agendar notificacao.
- Cancelar notificacao.
- Detectar eventos notificaveis.

## Telas Previstas

- Preferencias de notificacao.

## Testes Necessarios

- Regras de disparo.
- Preferencias.
- Cancelamento.

## Criterios de Aceite

- Notificacoes locais funcionam.
- Usuario pode desativar.
- Sem dependencia de internet.

## Riscos

- Permissoes Android.
- Excesso de notificacoes.

## Checklist de Conclusao

- Permissoes documentadas.
- Testes adicionados.
- Release notes atualizadas.
