# PRD - CompraCerta

## Visao do produto

CompraCerta e um aplicativo mobile para organizar compras domesticas, produtos e categorias. O projeto nasce como uma solucao local-first e evolutiva, preparada para estoque, historico, listas de compras, dashboard, relatorios e recursos inteligentes.

## Problema

Pessoas que fazem compras recorrentes frequentemente enfrentam:

- esquecimento de itens importantes;
- compra duplicada de produtos;
- falta de visao sobre produtos ativos e inativos;
- ausencia de controle de minimo e ideal;
- dificuldade para organizar produtos por categoria;
- falta de historico estruturado para tomar decisoes melhores.

## Publico-alvo

- Usuarios que organizam compras domesticas.
- Familias que precisam controlar produtos recorrentes.
- Pessoas que desejam reduzir desperdicio e esquecimento.
- Usuarios interessados em sugestoes futuras baseadas em consumo.

## Objetivo principal

Criar uma base confiavel para cadastro, organizacao e evolucao inteligente de compras, mantendo simplicidade de uso e arquitetura tecnica sustentavel.

## Funcionalidades atuais

### Ambiente

- Flutter e Dart.
- Material Design 3.
- Clean Architecture.
- Riverpod.
- Go Router.
- Drift/SQLite.
- Testes automatizados.

### Categorias

- Seed inicial via JSON.
- Hierarquia por `categoriaPaiId`.
- Controle para evitar duplicidade.
- Listagem de categorias.

### Produtos

- Cadastro e edicao.
- Vinculo com categoria.
- Busca por nome.
- Filtro por categoria.
- Filtro por status.
- Ativacao/desativacao logica.

### Estoque

- Controle de quantidade atual por produto.
- Movimentacoes de entrada, saida e ajuste.
- Identificacao de produtos ativos abaixo do minimo.
- Bloqueio de estoque negativo.

## Funcionalidades futuras

- Historico de compras.
- Lista de compras.
- Dashboard.
- Motor inteligente local.
- Integracao com IA.
- Relatorios.
- Notificacoes.
- Release APK/AAB.

## Regras de negocio atuais

- Categoria padrao vem do seed JSON.
- Seed de categorias deve rodar apenas uma vez por chave.
- Categoria pode ter categoria pai.
- Produto deve pertencer a uma categoria existente.
- Produto deve possuir nome e unidade de medida.
- Quantidades minima e ideal devem ser nao negativas.
- Produto nao deve ser excluido fisicamente.
- Produto deve ser desativado por `isAtivo`.
- Estoque nao pode ficar negativo.
- Toda movimentacao de estoque deve registrar quantidade anterior e final.
- Produtos inativos nao recebem movimentacao operacional na Sprint 05.

## Fluxos principais

### Consultar categorias

1. Usuario acessa Categorias.
2. App garante seed inicial.
3. Usuario visualiza categorias.

### Cadastrar produto

1. Usuario acessa Produtos.
2. Toca em Novo.
3. Preenche dados obrigatorios.
4. Seleciona categoria.
5. Salva o produto.

### Filtrar produtos

1. Usuario pesquisa por nome.
2. Seleciona categoria, se desejar.
3. Escolhe status.
4. App atualiza a lista.

### Desativar produto

1. Usuario aciona controle de status.
2. App altera `isAtivo`.
3. Produto permanece no banco.

### Ajustar estoque

1. Usuario acessa Estoque.
2. Seleciona um produto.
3. Informa entrada, saida ou ajuste.
4. App valida a quantidade e registra a movimentacao.

## Criterios de sucesso

- Usuario cadastra produto sem friccao.
- Usuario encontra produtos rapidamente.
- Categorias nao duplicam.
- Produtos inativos continuam historicamente preservados.
- Arquitetura suporta proximas features sem reescrita.
- Testes continuam passando a cada evolucao.
