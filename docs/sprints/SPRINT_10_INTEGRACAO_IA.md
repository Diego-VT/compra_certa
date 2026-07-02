# Sprint 10 - Integracao com IA

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

- Decisao registrada.
- Politica de dados atualizada.
- Testes com mocks.
