# Sprint 12 - Notificacoes

## Status

Concluida em 2026-07-14. Sprint finalizada com contrato local de notificacoes, preferencias padrao, deteccao de eventos de estoque baixo e listas pendentes, agendamento/cancelamento deduplicado, testes automatizados e documentacao atualizada.

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

- Permissoes Android permanecem risco da integracao nativa futura.
- Excesso de notificacoes mitigado por chaves e IDs estaveis por evento.

## Observacoes de Encerramento

- Cliente padrao de notificacoes permanece desativado para evitar dependencia de plugin, permissao Android/iOS e comportamento de plataforma antes da Sprint 13.
- Nao houve alteracao de schema Drift/SQLite.
- Preferencias foram implementadas como estado padrao em provider, sem persistencia local nesta etapa.

## Checklist de Conclusao

- [x] Sprint iniciada conforme documentacao oficial.
- [x] Contrato do service de notificacoes criado em `services/notificacoes`.
- [x] Preferencias de notificacao definidas.
- [x] Regras de disparo para estoque baixo implementadas.
- [x] Regras de disparo para listas pendentes implementadas.
- [x] Cancelamento/desativacao de notificacoes implementado.
- [x] Permissoes documentadas.
- [x] Testes adicionados.
- [x] Revisao final da sprint.
- [x] `flutter analyze` executado.
- [x] `flutter test` executado.
- [x] Release notes atualizadas.
