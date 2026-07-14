# Sprint 10 - Integracao com IA

## Status

Concluida em 2026-07-14. Sprint finalizada com contrato de IA externa, prompt versionado, sanitizacao de contexto, fallback local, acionamento manual na tela de sugestoes, validacao automatizada e documentacao atualizada.

## Objetivo

Adicionar integracao opcional com IA externa, acionada sob demanda.

## Escopo

- Contrato de servico de IA.
- Prompts versionados.
- Fallback sem IA.
- Controle de dados enviados.

## Fora do Escopo

- Dependencia obrigatoria de internet.
- Modelo local pesado.
- Envio automatico de dados sensiveis.

## Regras de Negocio

- IA e opcional.
- Usuario deve acionar recurso.
- App deve continuar funcionando sem IA.

## Arquitetura Envolvida

Service externo isolado por contrato e provider.

## Modulos Envolvidos

- `services/ia`
- `features/inteligencia`

## Tabelas Afetadas

- Nenhuma obrigatoria inicialmente.
- Persistencia futura de sugestoes pode usar `sugestoes_inteligentes`.

## Providers

- Provider de cliente de IA.
- Provider de usecase de sugestoes externas.

## Repositories

- Contrato para gateway de IA, se necessario.

## Usecases

- Solicitar sugestao externa.
- Sanitizar contexto enviado.
- Aplicar fallback local.

## Telas Previstas

- Acao opcional em sugestoes ou lista de compras.

## Testes Necessarios

- Fallback sem internet.
- Mock de servico externo.
- Validacao de dados enviados.

## Criterios de Aceite

- IA nao bloqueia uso basico.
- Falhas sao tratadas.
- Privacidade documentada.

## Riscos

- Custo de API.
- Exposicao de dados.
- Dependencia externa instavel.

## Checklist de Conclusao

- [x] Contrato de servico de IA criado em `services/ia`.
- [x] Cliente padrao desativado para preservar uso offline e evitar dependencia de credenciais.
- [x] Prompt versionado registrado em asset.
- [x] Sanitizacao de contexto implementada antes de envio para IA.
- [x] Fallback local implementado para falha, ausencia de rede ou IA nao configurada.
- [x] Acionamento manual adicionado na tela de sugestoes.
- [x] Testes com mocks criados.
- [x] Decisao registrada.
- [x] Politica de dados atualizada.
- [x] Revisao final da sprint.
- [x] `flutter analyze` executado.
- [x] `flutter test` executado.
