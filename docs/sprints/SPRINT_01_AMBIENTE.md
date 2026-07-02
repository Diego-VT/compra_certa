# Sprint 01 - Ambiente

## Status

Concluida.

## Objetivo

Criar a base profissional do projeto CompraCerta, separada de outros projetos, preparada para desenvolvimento incremental, testes e expansao futura.

## Escopo

- Criar projeto Flutter `compra_certa`.
- Configurar Clean Architecture.
- Configurar Riverpod para estado e injecao de dependencia.
- Configurar Go Router para navegacao.
- Configurar Material Design 3.
- Preparar tema claro e escuro.
- Configurar Drift/SQLite como banco local.
- Criar estrutura inicial de pastas.
- Criar README inicial.

## Fora do Escopo

- Categorias.
- Produtos.
- Estoque.
- Lista de compras.
- IA.
- Publicacao em loja.

## Regras de Negocio

- O projeto deve ser independente do `gestao_emprestimos_mobile`.
- O app deve funcionar como base offline-first.
- Nenhuma funcionalidade de negocio deve ser implementada antes da arquitetura base.

## Arquitetura Envolvida

Clean Architecture modular por feature, com separacao entre `app`, `core`, `database`, `features`, `services` e `shared`.

## Modulos Envolvidos

- `app`
- `core`
- `database`
- `features`
- `services`
- `shared`

## Tabelas Afetadas

- Nenhuma tabela de negocio criada nesta sprint.
- Banco preparado para uso futuro com Drift/SQLite.

## Providers

- Provider global de banco.
- Provider de router.
- Provider de tema.

## Repositories

- Nenhum repository de negocio nesta sprint.

## Usecases

- Nenhum usecase de negocio nesta sprint.

## Telas Previstas

- Tela base/bootstrap do ambiente.
- Estrutura preparada para telas futuras.

## Testes Necessarios

- Validar que o app compila.
- Validar estrutura inicial com `flutter analyze`.
- Validar testes base com `flutter test`.

## Criterios de Aceite

- Projeto Flutter criado em pasta separada.
- Arquitetura inicial criada.
- Riverpod configurado.
- Go Router configurado.
- Material Design 3 configurado.
- Tema claro e escuro preparados.
- Drift configurado.
- `flutter analyze` sem erros.
- `flutter test` sem erros.

## Riscos

- Ambiente local depender de caminho absoluto do Flutter.
- `flutter` e `dart` nao estarem no PATH.
- BootstrapPage ficar sem funcao clara quando a home oficial passar a ser Produtos.

## Oportunidades de Melhoria

- Documentar oficialmente que `/produtos` e a home atual, caso essa decisao seja mantida.
- Avaliar remocao ou reaproveitamento da BootstrapPage quando houver dashboard.
- Criar testes de navegacao para rotas principais.

## Checklist de Conclusao

- Escopo validado.
- Estrutura criada.
- Dependencias configuradas.
- Documentacao inicial criada.
- `flutter analyze` executado com sucesso.
- `flutter test` executado com sucesso.
- Sprint marcada como concluida.
