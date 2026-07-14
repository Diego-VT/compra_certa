# Release Notes - CompraCerta

Este arquivo registra as versoes do CompraCerta em linguagem amigavel para usuarios, testers e publicacao futura.

## Sprint 11 - Relatorios

Status: publicada no GitHub em 2026-07-14 conforme processo oficial.

### Destaques

- Nova tela de relatorios.
- Filtros rapidos por periodo.
- Resumo de compras e itens do periodo.
- Produtos mais comprados.
- Consumo por categoria.

### Observacoes

- Relatorios usam consultas agregadas no banco.
- Nao houve alteracao de schema Drift/SQLite.
- Exportacao permanece futura.
- `flutter analyze` e `flutter test` foram executados com sucesso.

## 0.10.0 - Integracao com IA

Status: preparada em 2026-07-14 conforme `VERSIONING.md` e `docs/RELEASE_PROCESS.md`.

### Destaques

- Primeira camada para IA externa opcional.
- IA acionada manualmente na tela de sugestoes.
- Prompt versionado para orientar respostas.
- Contexto minimizado antes de qualquer envio.
- Fallback local quando IA externa nao esta configurada ou falha.
- Protecao contra multiplas consultas simultaneas.

### Observacoes

- Nenhuma chave de API foi adicionada ao repositorio.
- O cliente externo permanece desativado por padrao.
- O app continua funcionando offline.
- `flutter analyze` e `flutter test` foram executados com sucesso.

## 0.9.0 - Motor Inteligente Local

Status: preparada para publicacao no GitHub em 2026-07-06, com commit e push aprovados pelo usuario.

### Destaques

- Novo motor inteligente local com sugestoes explicaveis.
- Sugestoes por estoque abaixo do minimo.
- Sugestoes por consumo recorrente recente.
- Criacao de lista de compras a partir de uma sugestao.
- Funcionamento offline, sem IA externa e sem modelo local pesado.

### Observacoes

- Release alinhada ao mapa de versoes do `VERSIONING.md`.
- Nao houve alteracao de schema Drift/SQLite nesta etapa.
- `flutter analyze` e `flutter test` foram executados com sucesso.
- Commit e push foram aprovados para fechamento em 2026-07-06.
- Criacao de tag Git permanece fora deste fechamento ate solicitacao explicita.

## 0.8.0 - Dashboard

Status: publicada no GitHub em 2026-07-06.

### Destaques

- Novo dashboard inicial com resumo operacional do app.
- Indicadores rapidos para estoque, listas abertas e compras recentes.
- Navegacao direta para os modulos mais relevantes.
- Melhor experiencia para identificar itens que exigem atencao.
- Base para evolucoes futuras de analytics e acompanhamento.

### Observacoes

- Release alinhada ao mapa de versoes do `VERSIONING.md`.
- `dart run build_runner build --delete-conflicting-outputs`, `flutter analyze` e `flutter test` foram executados com sucesso em 2026-07-06.
- Commit e push foram aprovados para fechamento em 2026-07-06.

## 0.7.0 - Lista de Compras

Status: preparada para revisao tecnica em 2026-07-03.

### Destaques

- Criacao de listas de compras offline.
- Adicao de produtos a lista.
- Marcacao de itens comprados.
- Geracao de lista a partir de estoque baixo.
- Base para sugestoes locais futuras.

### Observacoes

- Release alinhada ao mapa de versoes do `VERSIONING.md`.
- `flutter analyze` e `flutter test` foram executados com sucesso.
- Commit, push e criacao de tag Git foram mantidos pendentes aguardando aprovacao do usuario.

## 0.6.0 - Historico de Compras

Status: publicada no GitHub em 2026-07-03.

### Destaques

- Historico de compras realizadas.
- Registro de compras com multiplos itens.
- Detalhe da compra.
- Consultas por periodo com carregamento limitado.
- Filtro por periodo na tela de historico.
- Carregamento incremental com "Carregar mais".
- Base para relatorios e consumo futuro.

### Observacoes

- Release alinhada ao mapa de versoes do `VERSIONING.md`.
- `flutter analyze` e `flutter test` foram executados com sucesso.

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
