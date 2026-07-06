# Sprint 09 - Motor Inteligente Local

## Status

Concluida em 2026-07-06. Implementacao do motor inteligente local finalizada com sugestoes sob demanda, validacao automatizada, documentacao atualizada e aprovacao do usuario para commit e push.

## Objetivo

Gerar sugestoes de compra com regras locais leves e explicaveis.

## Escopo

- Sugestao por estoque baixo.
- Sugestao por consumo recorrente.
- Explicacao da regra aplicada.

## Fora do Escopo

- IA externa.
- Modelo local pesado.
- Sincronizacao.

## Regras de Negocio

- Motor deve funcionar offline.
- Regras devem ser explicaveis.
- Processamento nao pode travar o app.

## Arquitetura Envolvida

Feature ou service local de inteligencia sob domain/application.

## Modulos Envolvidos

- `features/inteligencia`
- `features/estoque`
- `features/compras`
- `features/listas_compras`

## Tabelas Afetadas

- Sem alteracao de schema nesta etapa.
- Futuras: `sugestoes_inteligentes`, caso a persistencia de sugestoes seja aprovada em sprint posterior.
- Leitura de estoque e historico.

## Providers

- Providers de sugestoes.

## Repositories

- `SugestaoInteligenteRepository` para gerar sugestoes locais sob demanda.

## Usecases

- Gerar sugestoes locais.
- Listar sugestoes geradas sob demanda.
- Criar lista de compras a partir de uma sugestao gerada sob demanda.
- Marcar sugestao como ignorada permanece fora desta primeira implementacao por nao haver persistencia.

## Telas Previstas

- Lista de sugestoes.
- Criacao de lista de compras a partir de sugestao.

## Testes Necessarios

- Regras de sugestao.
- Priorizacao.
- Fallback sem dados.

## Criterios de Aceite

- Sugestoes explicaveis.
- Funciona offline.
- Performance preservada.

## Riscos

- Regras complexas demais.
- Sugestoes pouco uteis sem historico suficiente.

## Checklist de Conclusao

- [x] Regras documentadas.
- [x] Feature `inteligencia` iniciada.
- [x] Sugestao por estoque baixo implementada.
- [x] Sugestao por consumo recorrente implementada.
- [x] Regras principais movidas para servico de dominio.
- [x] Criacao de lista a partir de sugestao implementada.
- [x] Testes unitarios iniciais criados.
- [x] Testes de widget da tela de sugestoes criados.
- [x] Teste de criacao de lista a partir de sugestao criado.
- [x] Impacto de performance avaliado para processamento sob demanda.
- [x] `flutter analyze` executado.
- [x] `flutter test` executado.
- [x] Tela revisada.
- [x] Documentacao final atualizada.
- [x] Revisao tecnica final.
- [x] Aprovacao do usuario para commit e push.
