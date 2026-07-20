# Plano de Testes - CompraCerta

## Objetivo

Definir a estrategia de testes do CompraCerta para manter qualidade tecnica e seguranca nas evolucoes.

## Comandos obrigatorios

```bash
flutter analyze
flutter test
```

Quando possivel, validar tambem em dispositivo fisico Android simples ou intermediario.

Quando houver mudancas Drift:

```bash
dart run build_runner build
```

## Testes unitarios

Devem cobrir:

- regras de negocio puras;
- validacoes;
- calculos de status;
- transformacoes simples;
- filtros.

Exemplos atuais:

- filtro de produtos por nome, categoria e status;
- alteracao logica de status do produto.
- regras de estoque para entrada, saida, ajuste e minimo.
- regras de lista de compras para criacao, duplicidade, marcacao e geracao por estoque baixo.
- regras de notificacao para estoque baixo, listas pendentes, preferencias e deduplicacao.

## Testes de repository

Devem validar contratos de repositories usando datasources controlados ou banco em memoria.

Objetivos:

- garantir que repository delega corretamente;
- validar retornos esperados;
- evitar acoplamento com UI.

## Testes de usecases

Devem cobrir:

- entrada esperada;
- saida esperada;
- erros de negocio;
- chamadas ao repository.

Usecases simples podem ser cobertos indiretamente por testes de datasource/repository, mas regras complexas devem ter testes especificos.

## Testes de widget

Devem cobrir:

- tela vazia;
- estados de carregamento;
- estados de erro;
- interacoes principais;
- validacoes de formulario quando relevante.

Teste atual:

- tela inicial de produtos sem registros.

## Testes e verificacoes de performance

Devem ser considerados em features com listas, consultas ou processamento maior.

Critérios:

- Tela inicial abre rapidamente.
- Listagens grandes usam paginacao, busca ou filtro sob demanda.
- Busca de produtos nao trava a interface.
- Categorias podem ser filtradas por nivel, busca ou filtro quando necessario.
- Historico de compras nao carrega todos os registros sem necessidade.
- Dashboards e relatorios carregam dados sob demanda.
- Banco evita duplicidades e consultas repetidas.
- IA externa e opcional e executada apenas por acao ou fluxo especifico.
- IA local pesada nao deve ser executada no aparelho.

Estrategias:

- Testar filtros em banco em memoria.
- Criar massas maiores em testes quando a feature justificar.
- Medir manualmente em dispositivo fisico quando possivel.
- Evitar testes que dependam de internet para funcionalidades principais.

## Testes de seed

Devem garantir:

- seed executa apenas uma vez;
- seed nao duplica por `id`;
- seed nao duplica por `caminhoCompleto`;
- hierarquia por `categoriaPaiId` e preservada.

Testes atuais:

- seed de categorias executa uma vez.
- duplicidade de categorias e evitada.

## Testes de formulario

Devem validar:

- campos obrigatorios;
- numeros nao negativos;
- selecao de categoria;
- salvamento de cadastro;
- edicao de cadastro.

No modulo Produtos, parte das regras ja e validada em testes de datasource. Testes de widget do formulario devem ser adicionados quando o fluxo visual se estabilizar.

## Testes atuais de estoque

Cobrem:

- criacao de estoque para produto;
- ajuste de quantidade;
- movimentacoes de entrada;
- movimentacoes de saida;
- status abaixo do minimo;
- status adequado;
- status acima do ideal;
- bloqueio de estoque negativo;
- bloqueio de movimentacao para produto inativo;
- consulta de produtos ativos abaixo do minimo;
- exclusao de produto com saldo igual ao minimo da consulta de reposicao.

## Testes atuais de lista de compras

Cobrem:

- criacao de lista;
- adicao de produto ativo;
- bloqueio de item duplicado;
- marcar item como comprado;
- geracao por estoque baixo;
- bloqueio de produto inativo;
- filtro e paginacao de listas;
- funcionamento offline.

## Testes atuais de motor inteligente

Cobrem:

- sugestao por estoque baixo;
- sugestao por recorrencia;
- ignorar produtos inativos;
- explicacao da sugestao;
- fallback sem IA externa.
- validacao de limite para preservar processamento leve.
- regra de dominio isolada do datasource.
- tela de sugestoes com dados e estado vazio.
- criacao de lista de compras a partir de uma sugestao.

## Testes futuros de IA

Devem usar mocks/fakes.

Devem cobrir:

- sucesso;
- erro de rede;
- resposta invalida;
- timeout;
- fallback local;
- nenhum dado sensivel enviado indevidamente.
- acionamento sob demanda, sem processamento local pesado.

Testes iniciais da Sprint 10 cobrem:

- contexto sanitizado antes do envio para IA;
- fallback quando o cliente externo falha;
- nao acionamento da IA quando nao ha sugestoes locais;
- acionamento manual pela tela de sugestoes.

## Testes atuais de relatorios

Cobrem:

- agregacao de compras por produto e categoria;
- filtro por periodo;
- estado vazio sem compras;
- validacao de periodo invalido;
- tela de relatorios com dados agregados;
- estado vazio da tela de relatorios.

## Testes atuais de notificacoes

Cobrem:

- deteccao de eventos de estoque baixo;
- deteccao de listas de compras pendentes;
- respeito a preferencia geral de notificacoes;
- respeito a preferencias por tipo de alerta;
- chaves e IDs estaveis por evento notificavel;
- agendamento sem duplicar o mesmo evento;
- cancelamento sem repetir o mesmo evento.
- persistencia local das preferencias;
- listas abertas sem itens pendentes nao geram alerta.

## Criterios de aceite para PRs

- `flutter analyze` sem issues.
- `flutter test` com todos os testes passando.
- Impacto de performance avaliado.
- Novas regras cobertas por teste.
- Documentacao atualizada quando necessario.
- Nenhuma funcionalidade fora do escopo.
