# Sprint 12 - Notificacoes

## Status

Concluida e revisada em 2026-07-20. Sprint finalizada com notificacoes locais nativas, preferencias persistentes, tela de configuracao, deteccao de eventos de estoque baixo e listas pendentes, sincronizacao deduplicada, testes automatizados e documentacao atualizada.

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

- Nenhuma. As preferencias booleanas usam armazenamento chave-valor local.

## Providers

- Provider de notificacoes.
- Provider de preferencias.

## Repositories

- Repository de preferencias com persistencia local.

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

- Permissoes e exibicao Android permanecem pendentes de validacao em dispositivo real.
- Excesso de notificacoes mitigado por chaves e IDs estaveis por evento.

## Observacoes de Encerramento

- Cliente padrao integrado ao `flutter_local_notifications` para Android e iOS.
- Permissao solicitada somente depois de uma acao explicita do usuario na tela de preferencias.
- Sincronizacao cancela lembretes obsoletos antes de exibir os eventos ativos.
- Sincronizacao ocorre na abertura, retomada do app e por acao manual do usuario.
- Listas abertas sem itens pendentes nao geram notificacao.
- Nao houve alteracao de schema Drift/SQLite.
- Preferencias sao persistidas com armazenamento chave-valor local.

## Checklist de Conclusao

- [x] Sprint iniciada conforme documentacao oficial.
- [x] Contrato do service de notificacoes criado em `services/notificacoes`.
- [x] Preferencias de notificacao definidas.
- [x] Tela de preferencias criada e acessivel pelo dashboard.
- [x] Tela responsiva com estado visual, feedback e orientacao de privacidade.
- [x] Preferencias persistidas entre execucoes.
- [x] Integracao nativa Android/iOS implementada.
- [x] Regras de disparo para estoque baixo implementadas.
- [x] Regras de disparo para listas pendentes implementadas.
- [x] Cancelamento/desativacao de notificacoes implementado.
- [x] Permissoes documentadas.
- [x] Testes adicionados.
- [x] Revisao final da sprint.
- [x] `flutter analyze` executado.
- [x] `flutter test` executado.
- [x] Release notes atualizadas.
