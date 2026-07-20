# Technical Debt - CompraCerta

Este documento registra dividas tecnicas, riscos de manutencao e melhorias estruturais futuras.

## Como utilizar

Ao identificar uma divida tecnica:

1. Registrar titulo.
2. Descrever contexto.
3. Informar impacto.
4. Definir prioridade.
5. Relacionar modulo afetado.
6. Propor acao recomendada.
7. Revisar ao final de cada sprint.

## Classificacao

- Baixa: melhoria sem impacto imediato.
- Media: pode dificultar manutencao futura.
- Alta: pode gerar bugs, lentidao ou bloqueio de evolucao.
- Critica: precisa ser resolvida antes de continuar uma sprint.

## Registro

### TD-001 - Validar performance em dispositivo fisico

Prioridade: media.

Modulo: app geral.

Contexto: testes automatizados passam, mas validacao em aparelho simples/intermediario deve ocorrer antes de release.

Impacto: risco de comportamento diferente em dispositivo real.

Acao recomendada: testar listagens, banco local e navegacao em Android fisico.

Status: aberta.

### TD-005 - Validar integracoes nativas Android

Prioridade: alta.

Modulo: notificacoes e relatorio PDF.

Contexto: testes automatizados validam regras e geracao do documento, mas nao substituem permissao, exibicao de notificacao e compartilhamento em aparelho real.

Acao recomendada: executar o checklist da Sprint 13 em dispositivo Android conectado e registrar modelo, versao do Android e resultado.

Status: aberta.

### TD-002 - Planejar indices para consultas futuras

Prioridade: media.

Modulo: banco.

Contexto: estoque, historico e relatorios exigirao consultas frequentes por produto, categoria, periodo e status.

Impacto: risco de lentidao com grande volume de dados.

Acao recomendada: adicionar indices conforme queries reais forem implementadas.

Status: aberta.

### TD-003 - Otimizar composicao da listagem de produtos

Prioridade: media.

Modulo: produtos.

Contexto: a listagem de produtos monta itens de exibicao com dados de categoria. No volume atual isso e aceitavel, mas a evolucao do app pode exigir consultas com join, paginacao ou cache controlado.

Impacto: risco de consumo desnecessario de memoria quando produtos e categorias crescerem.

Acao recomendada: avaliar query com join e carregamento incremental antes de bases grandes ou relatorios.

Status: aberta.

### TD-004 - Ampliar testes de widget do modulo de estoque

Prioridade: baixa.

Modulo: estoque.

Contexto: a Sprint 05 cobre as regras centrais de estoque com testes de datasource, mas ainda nao possui testes de widget para filtro visual, estados vazios e formulario de ajuste.

Impacto: risco baixo de regressao visual ou de navegacao nao capturada por testes unitarios.

Acao recomendada: criar testes de widget para a tela de estoque e para o formulario de ajuste antes da preparacao de release ampliada.

Status: aberta.
