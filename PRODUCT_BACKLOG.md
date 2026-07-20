# Product Backlog - CompraCerta

Este backlog organiza a evolucao do CompraCerta em niveis de Epic, Feature, User Story, Task e Subtask. Ele deve ser revisado ao final de cada sprint.

## Epic E-001 - Fundacao do Produto

Prioridade: alta.

Descricao: criar base tecnica, arquitetura, documentacao e governanca.

Dependencias: nenhuma.

Criterios de aceite:

- Projeto Flutter criado.
- Arquitetura definida.
- Documentacao inicial disponivel.
- `flutter analyze` e `flutter test` sem erros.

Features:

- F-001 Ambiente Flutter profissional.
- F-002 Clean Architecture.
- F-003 Documentacao e governanca.

User Stories:

- US-001: Como desenvolvedor, quero uma base modular para evoluir o app com baixo acoplamento.
- US-002: Como agente de IA, quero documentacao clara para atuar sem quebrar padroes.

Tasks:

- Criar estrutura de pastas.
- Configurar Riverpod, Go Router, Material 3 e Drift.
- Criar documentacao oficial.

Estimativa: concluida.

## Epic E-002 - Catalogo de Produtos

Prioridade: alta.

Descricao: permitir organizar categorias e produtos.

Dependencias: fundacao do produto.

Criterios de aceite:

- Categorias carregadas por seed sem duplicidade.
- Produtos cadastrados com categoria.
- Produtos filtrados por busca, categoria e status.

Features:

- F-004 Categorias.
- F-005 Produtos.
- F-006 Melhorias em Produtos.

User Stories:

- US-003: Como usuario, quero visualizar categorias para organizar meus produtos.
- US-004: Como usuario, quero cadastrar produtos com categoria e unidade.
- US-005: Como usuario, quero buscar e filtrar produtos para encontrar itens rapidamente.
- US-006: Como usuario, quero desativar produtos sem apaga-los.

Tasks:

- Manter seed de categorias.
- Finalizar listagem de produtos.
- Cobrir filtros e status com testes.

Estimativa: melhorias em revisao.

## Epic E-003 - Estoque e Reposicao

Prioridade: alta.

Descricao: controlar quantidades atuais, minimas e ideais para apoiar reposicao.

Dependencias: produtos.

Criterios de aceite:

- Estoque registrado por produto.
- Movimentacoes rastreadas.
- Itens abaixo do minimo identificados.

Features:

- F-007 Estoque.
- F-008 Movimentacoes de estoque.
- F-009 Alertas locais de reposicao.

User Stories:

- US-007: Como usuario, quero registrar quantidade atual para saber o que tenho.
- US-008: Como usuario, quero ver produtos abaixo do minimo.
- US-009: Como usuario, quero ajustar estoque rapidamente.

Tasks:

- Criar tabelas de estoque.
- Criar usecases de entrada, saida e ajuste.
- Criar testes de regras de minimo e ideal.

Estimativa: em revisao.

## Epic E-004 - Compras e Historico

Prioridade: alta.

Descricao: registrar compras realizadas e consultar historico de consumo.

Dependencias: produtos e estoque.

Criterios de aceite:

- Compra criada com itens.
- Historico filtrado por periodo.
- Consultas otimizadas para grandes volumes.

Features:

- F-010 Historico de compras.
- F-011 Itens de compra.
- F-012 Consultas por periodo.

User Stories:

- US-010: Como usuario, quero registrar uma compra realizada.
- US-011: Como usuario, quero consultar compras por periodo.

Tasks:

- Modelar compras e itens.
- Criar repositories e usecases.
- Criar listagem incremental.

Estimativa: media.

## Epic E-005 - Lista de Compras

Prioridade: alta.

Descricao: planejar compras futuras e marcar itens comprados.

Dependencias: produtos, estoque e historico.

Criterios de aceite:

- Lista criada offline.
- Itens adicionados e marcados como comprados.
- Lista pode ser gerada a partir de estoque baixo.

Features:

- F-013 Listas de compras.
- F-014 Itens da lista.
- F-015 Geracao assistida.

User Stories:

- US-012: Como usuario, quero criar e acompanhar uma lista de compras.
- US-013: Como usuario, quero gerar lista com produtos abaixo do minimo.

Tasks:

- Criar modelo de listas.
- Criar tela de lista.
- Criar testes de fluxo.

Estimativa: em revisao.

## Epic E-006 - Inteligencia e Analise

Prioridade: media.

Descricao: oferecer sugestoes, dashboard, relatorios e IA opcional.

Dependencias: estoque, compras e lista.

Criterios de aceite:

- Sugestoes locais explicaveis.
- Dashboards sob demanda.
- IA externa opcional e com fallback.

Features:

- F-016 Dashboard.
- F-017 Motor inteligente local.
- F-018 Integracao com IA.
- F-019 Relatorios.
- F-020 Notificacoes.

User Stories:

- US-014: Como usuario, quero visualizar o dashboard.
- US-015: Como usuario, quero receber sugestoes inteligentes locais.
- US-016: Como usuario, quero usar IA somente quando eu decidir.
- US-017: Como usuario, quero relatorios simples de compras.
- US-020: Como usuario, quero notificacoes de reposicao.
- US-021: Como usuario, quero gerar o relatorio de uma lista de compras.

Tasks:

- Criar regras locais leves.
- Criar contratos de IA externa.
- Criar relatorios agregados.

Estimativa: alta.

## Melhoria - Relatorio da Lista de Compras

Prioridade: media.

User Story: US-021.

Entregas:

- Pre-visualizacao individual da lista.
- Resumo de itens comprados e pendentes.
- Geracao e compartilhamento de PDF offline.
- Testes de dominio, documento e interface.
