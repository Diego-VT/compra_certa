# Changelog

Todas as mudancas relevantes deste projeto serao documentadas neste arquivo.

O formato segue o padrao Keep a Changelog, e o projeto usa versionamento semantico quando aplicavel.

Tipos de mudanca:

- Added: novas funcionalidades, documentos ou capacidades.
- Changed: alteracoes em comportamento, documentacao ou estrutura existente.
- Deprecated: recursos ainda existentes, mas planejados para remocao.
- Removed: recursos removidos.
- Fixed: correcoes de erros.
- Security: ajustes de seguranca ou privacidade.

## [0.7.0] - 2026-07-03

### Added

- Modulo de Lista de Compras com Clean Architecture, Riverpod e Repository Pattern.
- Tabelas Drift `listas_compras` e `itens_lista_compras`.
- Migration do schema local para a versao `5`.
- Tela de listas de compras com filtro por status e carregamento incremental.
- Tela de criacao de lista.
- Tela de detalhe da lista com adicao de itens e marcacao de comprado.
- Geracao de lista a partir de produtos ativos abaixo do minimo.
- Indices locais para consultas de listas e itens.
- Testes automatizados para criacao, duplicidade, marcacao de item e geracao por estoque baixo.

### Changed

- Produtos, Estoque e Historico de Compras agora possuem atalho para Listas de Compras.

### Verified

- `flutter analyze` executado com sucesso durante a preparacao da release `0.7.0`.
- `flutter test` executado com sucesso durante a preparacao da release `0.7.0`.

## [Unreleased]

### Notes

- Proximas entregas continuam em planejamento.

## [0.6.0] - 2026-07-03

### Added

- Modulo de Historico de Compras com Clean Architecture, Riverpod e Repository Pattern.
- Tabelas Drift `compras` e `itens_compra`.
- Migration do schema local para a versao `4`.
- Tela de historico de compras realizadas.
- Tela de detalhe da compra.
- Tela de registro de compra com multiplos itens.
- Consulta de compras por periodo com `limit` e `offset`.
- Filtro por periodo na tela de historico.
- Carregamento incremental do historico com acao "Carregar mais".
- Indices locais para consultas de historico e itens de compra.
- Testes automatizados para registro, detalhe, filtro por periodo e paginacao de compras.

### Changed

- Produtos e Estoque agora possuem atalho de navegacao para Historico de Compras.
- Paginacao do historico agora usa ordenacao estavel por data e id.
- Filtro de data final passa a incluir compras feitas durante todo o dia selecionado.

## [0.5.0] - 2026-07-02

### Added

- Modulo de Estoque com Clean Architecture, Riverpod e Repository Pattern.
- Tabelas Drift `estoques` e `movimentacoes_estoque`.
- Migration do schema local para a versao `3`.
- Tela de resumo de estoque.
- Tela de ajuste de estoque por produto.
- Filtro visual para produtos ativos abaixo do minimo na tela de estoque.
- Movimentacoes de entrada, saida e ajuste.
- Indicadores de estoque abaixo do minimo, adequado e acima do ideal.
- Testes automatizados para regras de estoque.

### Changed

- Produtos agora possuem atalho de navegacao para Estoque.
- Consulta de produtos abaixo do minimo passou a ser filtrada diretamente no banco.
- Documentacao tecnica atualizada para refletir o schema `3` e a Sprint 05 em revisao.

### Fixed

- Rota invalida de ajuste de estoque agora retorna para a tela de estoque.
- Documentacao alinhada ao nome real da tabela `estoques`.

### Verified

- `flutter analyze` executado com sucesso durante a Sprint 05.
- `flutter test` executado com sucesso durante a Sprint 05.

## [0.4.0] - 2026-07-02

### Added

- Documentacao oficial do projeto.
- Roadmap de desenvolvimento.
- Regras de contribuicao.
- Registro de decisoes arquiteturais.
- Visao executiva do produto.
- Estrategia de produto.
- Requisitos nao funcionais.
- Processo oficial de release.
- Guia de versionamento semantico.
- Release notes em formato amigavel.
- Backlog de produto.
- User stories.
- Definicao de MVP.
- Project board textual.
- Milestones.
- Documentacao de seguranca.
- Registro de divida tecnica.
- Diretrizes UI/UX.
- Guia de estilo de codigo.
- Planejamento das sprints 04 a 13.
- Organizacao da pasta `docs/` por area.
- Retrospectivas oficiais das Sprints 01, 02 e 03 em `docs/sprints/`.
- Indice atualizado da pasta `docs/sprints/`.
- Melhorias da Sprint 04 em Produtos: busca, filtros, status logico e listagem enriquecida.

### Changed

- Documentacao tecnica consolidada em `docs/`.
- Governanca para agentes de IA e contribuidores.
- Roadmap com status oficiais por sprint.
- Correcoes de consistencia documental antes da transicao para desenvolvimento.
- Sprint 04 concluida conforme processo oficial de release.

### Verified

- `flutter analyze` executado com sucesso.
- `flutter test` executado com sucesso.

## [0.1.0] - 2026-07-02

### Added

- Projeto Flutter `compra_certa`.
- Clean Architecture modular por feature.
- Riverpod para estado e injecao de dependencia.
- Go Router para navegacao.
- Material Design 3.
- Tema claro e escuro.
- Drift/SQLite para banco local.
- Modulo de Categorias.
- Seed JSON de categorias com 596 registros.
- Controle de execucao de seed com `seed_executions`.
- Modulo de Produtos.
- Cadastro e edicao de produtos.
- Relacionamento entre produtos e categorias.
- Busca e filtros de produtos.
- Ativacao e desativacao logica de produtos.
- Testes automatizados para categorias e produtos.

### Verified

- `flutter analyze` executado com sucesso.
- `flutter test` executado com sucesso.
