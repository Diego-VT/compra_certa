# Release Notes - CompraCerta

Este arquivo registra as versoes do CompraCerta em linguagem amigavel para usuarios, testers e publicacao futura.

## Proxima versao

Status: versao `0.6.0` preparada localmente para Historico de Compras.

### Destaques previstos

- Historico de compras realizadas.
- Registro de compras com multiplos itens.
- Detalhe da compra.
- Consultas por periodo com carregamento limitado.
- Filtro por periodo na tela de historico.
- Carregamento incremental com "Carregar mais".
- Base para relatorios e consumo futuro.

## 0.5.0 - Estoque

Status: preparada localmente em 2026-07-02. Commit local criado; push e tag Git pendentes por verificacao SSH do GitHub.

### Destaques

- Controle de quantidade atual por produto.
- Movimentacoes de entrada, saida e ajuste.
- Identificacao de produtos ativos abaixo do minimo.
- Filtro dedicado para revisar itens abaixo do minimo.

### Observacoes

- Release preparada conforme `VERSIONING.md` e `docs/RELEASE_PROCESS.md`.
- `flutter analyze` e `flutter test` foram executados com sucesso.
- O envio ao GitHub e a criacao de tag Git dependem de aprovacao e resolucao da verificacao SSH.

## 0.4.0 - Melhorias em Produtos

### Destaques

- Documentacao oficial do projeto em evolucao.
- Governanca de desenvolvimento, produto, release e versionamento.
- Requisitos nao funcionais definidos com foco em performance, offline first e privacidade.
- Produtos com busca por nome, filtro por categoria, filtro por status e ativacao/desativacao logica.

### Observacoes

- A Sprint 04 foi concluida conforme processo oficial de release.
- Lista de compras e inteligencia artificial ainda nao fazem parte desta entrega.
- Esta versao representa a conclusao da etapa de Melhorias em Produtos.

## 0.1.0 - Base inicial

### O que foi entregue

- Criacao do projeto Flutter CompraCerta.
- Arquitetura inicial com Clean Architecture.
- Gerenciamento de estado com Riverpod.
- Navegacao com Go Router.
- Interface baseada em Material Design 3.
- Banco local com Drift/SQLite.
- Modulo de Categorias com seed JSON.
- Modulo de Produtos com cadastro, edicao, busca, filtros e ativacao/desativacao logica.
- Testes automatizados iniciais.

### Para quem e esta versao

Versao voltada a desenvolvimento e validacao tecnica inicial. Ainda nao e uma release final para usuarios de producao.
