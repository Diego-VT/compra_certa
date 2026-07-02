# Sprint 04 - Melhorias em Produtos

## Status

Concluida.

## Objetivo

Melhorar a usabilidade da listagem de produtos com busca, filtros e controle de status.

## Escopo

- Busca por nome.
- Filtro por categoria.
- Filtro por status.
- Ativar e desativar produto sem exclusao fisica.
- Preparar listagem para status de estoque futuro.

## Fora do Escopo

- Estoque.
- Lista de compras.
- IA.

## Regras de Negocio

- Produto nao deve ser removido fisicamente.
- `isAtivo` define status operacional.
- Busca deve evitar travar a interface.

## Arquitetura Envolvida

Clean Architecture com domain, data, application e presentation.

## Modulos Envolvidos

- `features/produtos`
- `features/categorias`

## Tabelas Afetadas

- `produtos`
- `categorias` somente leitura para filtros.

## Providers

- Providers de produtos.
- Providers de categorias para selecao.

## Repositories

- `ProdutoRepository`
- `CategoriaRepository` para apoio de leitura.

## Usecases

- Listar produtos para exibicao.
- Alterar status do produto.
- Salvar produto.

## Telas Previstas

- Listagem de produtos.
- Formulario de produto.

## Testes Necessarios

- Filtro por busca.
- Filtro por categoria.
- Filtro por status.
- Ativacao e desativacao logica.

## Criterios de Aceite

- `flutter analyze` sem erros.
- `flutter test` sem erros.
- Produto inativo permanece no banco.
- Listagem exibe dados principais.

## Riscos

- Rebuild excessivo da tela.
- Consulta sem filtro em volume alto.

## Checklist de Conclusao

- Escopo validado.
- Testes atualizados.
- Documentacao atualizada.
- Roadmap revisado.
- `flutter analyze` executado com sucesso.
- `flutter test` executado com sucesso.
- Aprovacao de encerramento recebida.
- Sprint marcada como concluida.
