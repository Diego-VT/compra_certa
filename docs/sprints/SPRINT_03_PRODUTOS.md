# Sprint 03 - Produtos

## Status

Concluida.

## Objetivo

Implementar o cadastro e edicao de produtos, vinculando cada produto a uma categoria existente e preparando a base para estoque, historico e lista de compras.

## Escopo

- Criar tabela `produtos`.
- Relacionar produto com categoria por `categoriaId`.
- Criar entidade e dados de formulario de produto.
- Criar datasource, repository, usecases e providers.
- Criar tela simples de listagem.
- Criar tela de cadastro e edicao.
- Validar formulario antes de salvar.
- Permitir definir produto ativo/inativo.
- Criar testes de cadastro e edicao.

## Fora do Escopo

- Busca avancada.
- Filtros por categoria/status.
- Ativar/desativar diretamente pela listagem.
- Estoque.
- Lista de compras.
- IA.

## Regras de Negocio

- Produto deve possuir nome.
- Produto deve possuir categoria existente.
- Produto deve possuir unidade de medida.
- Quantidade minima nao pode ser negativa.
- Quantidade ideal nao pode ser negativa.
- Produto deve ser persistido localmente.
- Produto inativo permanece no banco.

## Arquitetura Envolvida

Feature `produtos` seguindo Clean Architecture com contratos no dominio, implementacoes em data, providers em application e telas em presentation.

## Modulos Envolvidos

- `features/produtos`
- `features/categorias`
- `database`
- `core/router`

## Tabelas Afetadas

- `produtos`
- `categorias` como referencia por chave estrangeira.

## Providers

- Provider do datasource local de produtos.
- Provider do repository de produtos.
- Providers dos usecases de produtos.
- Provider de produto por id.
- Provider de listagem inicial.

## Repositories

- `ProdutoRepository`
- `ProdutoRepositoryImpl`

## Usecases

- `ListarProdutos`
- `BuscarProdutoPorId`
- `SalvarProduto`

## Telas Previstas

- Listagem de produtos.
- Formulario de novo produto.
- Formulario de edicao de produto.

## Testes Necessarios

- Cadastro de produto.
- Edicao de produto.
- Relacionamento com categoria.
- Validacoes basicas de formulario.

## Criterios de Aceite

- Produto cadastrado com categoria.
- Produto editado corretamente.
- Formulario valida campos obrigatorios.
- Quantidades numericas nao aceitam valores negativos.
- `flutter analyze` sem erros.
- `flutter test` sem erros.

## Riscos

- Erros ao salvar produto precisam de feedback visual mais claro.
- Testes de widget do formulario ainda devem ser ampliados.
- Usecases e repositories podem receber testes diretos quando regras ficarem mais complexas.

## Oportunidades de Melhoria

- Adicionar `SnackBar` ou estado de erro no formulario ao falhar salvamento.
- Criar testes de widget para validacoes do formulario.
- Criar indices futuros para `categoriaId` e `isAtivo` quando o volume crescer.
- Padronizar tratamento de erro de UI em `shared`.

## Checklist de Conclusao

- Escopo validado.
- Tabela criada.
- Repository, datasource, usecases e providers criados.
- Telas criadas.
- Testes criados.
- Documentacao atualizada.
- `flutter analyze` executado com sucesso.
- `flutter test` executado com sucesso.
- Sprint marcada como concluida.
