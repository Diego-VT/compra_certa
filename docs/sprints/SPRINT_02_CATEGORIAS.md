# Sprint 02 - Categorias

## Status

Concluida.

## Objetivo

Implementar o modulo de Categorias como base de classificacao dos produtos, com seed inicial via JSON e persistencia local em Drift/SQLite.

## Escopo

- Criar tabela `categorias`.
- Criar tabela `seed_executions`.
- Configurar asset JSON de categorias.
- Executar seed inicial uma unica vez por chave.
- Evitar duplicidades por `id` ou `caminhoCompleto`.
- Preservar hierarquia por `categoriaPaiId`.
- Criar datasource, repository, usecases e providers.
- Criar tela simples de listagem.
- Criar testes de seed e duplicidade.

## Fora do Escopo

- Cadastro manual de categorias personalizadas.
- Edicao de categorias.
- Exclusao ou desativacao de categorias pela UI.
- Produtos.
- Estoque.
- IA.

## Regras de Negocio

- Categoria padrao vem do seed JSON.
- Seed deve executar apenas uma vez por chave.
- Categorias nao devem duplicar `id`.
- Categorias nao devem duplicar `caminhoCompleto`.
- Categoria pode possuir categoria pai.
- Categorias devem funcionar offline.

## Arquitetura Envolvida

Feature `categorias` seguindo Clean Architecture com camadas `domain`, `data`, `application` e `presentation`.

## Modulos Envolvidos

- `features/categorias`
- `database`
- `assets/seeds`

## Tabelas Afetadas

- `categorias`
- `seed_executions`

## Providers

- Provider do datasource de asset.
- Provider do datasource local.
- Provider do repository.
- Provider do usecase de seed.
- Provider do usecase de listagem.
- Provider de categorias.

## Repositories

- `CategoriaRepository`
- `CategoriaRepositoryImpl`

## Usecases

- `SeedCategoriasIniciais`
- `ListarCategorias`

## Telas Previstas

- Tela de listagem de categorias.

## Testes Necessarios

- Seed executa apenas uma vez.
- Seed nao duplica por `id`.
- Seed nao duplica por `caminhoCompleto`.
- Hierarquia por `categoriaPaiId` e preservada.

## Criterios de Aceite

- Categorias carregadas do JSON.
- Seed controlado por `seed_executions`.
- Duplicidades evitadas.
- Categorias listadas em ordem compreensivel.
- `flutter analyze` sem erros.
- `flutter test` sem erros.

## Riscos

- Seed grande pode ficar custoso se cada categoria exigir consulta individual.
- Mudancas futuras no seed exigem chave versionada e cuidado para nao duplicar dados.
- Categorias personalizadas futuras exigirao regras de conflito com categorias padrao.

## Oportunidades de Melhoria

- Otimizar seed carregando IDs e caminhos existentes em lote.
- Criar testes para asset real de categorias.
- Criar filtro por nivel quando o volume de categorias exigir.

## Checklist de Conclusao

- Escopo validado.
- Tabelas criadas.
- Asset configurado.
- Seed implementado.
- Testes criados.
- Documentacao atualizada.
- `flutter analyze` executado com sucesso.
- `flutter test` executado com sucesso.
- Sprint marcada como concluida.
