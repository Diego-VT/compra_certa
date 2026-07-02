# Sprint 09 - Motor Inteligente Local

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

- Futuras: `sugestoes_inteligentes`.
- Leitura de estoque e historico.

## Providers

- Providers de sugestoes.

## Repositories

- `SugestaoInteligenteRepository` se houver persistencia.

## Usecases

- Gerar sugestoes locais.
- Listar sugestoes.
- Marcar sugestao como aplicada ou ignorada.

## Telas Previstas

- Lista de sugestoes.
- Inclusao de sugestao em lista de compras.

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

- Regras documentadas.
- Testes unitarios.
- Impacto de performance avaliado.
