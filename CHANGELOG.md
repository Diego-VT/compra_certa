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

## [Unreleased]

### Added

- Retrospectivas oficiais das Sprints 01, 02 e 03 em `docs/sprints/`.
- Indice atualizado da pasta `docs/sprints/`.

## [0.5.0] - 2026-07-02

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
