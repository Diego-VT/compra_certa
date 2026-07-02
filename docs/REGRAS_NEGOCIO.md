# Regras de Negocio - CompraCerta

## Categorias

### Categoria padrao

- Categorias padrao sao carregadas a partir do seed JSON.
- Categorias padrao possuem `isPadrao = true`.
- O seed deve executar apenas uma vez por chave.
- Categorias padrao podem ser usadas para classificar produtos.

### Categoria personalizada

Regra futura:

- Usuario podera criar categorias proprias.
- Categorias personalizadas devem ter `isPadrao = false`.
- Nao devem duplicar `caminhoCompleto`.
- Podem ser ativadas ou desativadas.

### Hierarquia

- Uma categoria pode ter uma categoria pai.
- Categorias raiz possuem `categoriaPaiId = null`.
- `nivel` indica profundidade.
- `caminhoCompleto` representa a arvore textual.

## Produtos

### Cadastro

- Produto deve possuir nome.
- Produto deve possuir categoria.
- Produto deve possuir unidade de medida.
- Produto deve possuir quantidade minima e ideal.
- Quantidades nao podem ser negativas.

### Produto ativo/inativo

- Produto ativo pode aparecer em fluxos principais.
- Produto inativo deve permanecer no banco.
- Produto inativo nao deve ser considerado por sugestoes futuras, salvo consulta historica.
- Produto deve ser desativado por `isAtivo = false`.
- Produto deve ser reativado por `isAtivo = true`.

### Performance em produtos

- Busca por produto deve ser feita sob demanda.
- Filtros por categoria e status devem evitar consultas desnecessarias.
- A listagem deve adotar paginacao ou carregamento incremental se o volume crescer.
- Produtos devem continuar disponiveis offline.

## Estoque

### Estoque minimo

Regra futura:

- Cada produto podera ter quantidade atual.
- Se quantidade atual for menor que `quantidadeMinima`, o produto deve ser sinalizado para reposicao.

### Estoque ideal

Regra futura:

- `quantidadeIdeal` indica quantidade recomendada.
- Sugestoes devem considerar diferenca entre estoque atual e ideal.

### Movimentacoes

Regra futura:

- Alteracoes de estoque devem gerar movimentacao.
- Movimentacoes devem indicar entrada, saida ou ajuste.
- Movimentacoes nao devem ser apagadas em fluxos comuns.

### Performance em estoque

Regra futura:

- Consultas de estoque devem priorizar produtos ativos.
- Produtos abaixo do minimo devem ser consultados por query otimizada.
- Quando necessario, indices devem ser criados para `produtoId` e campos usados em filtros.

## Sugestao automatica de compra

Regra futura:

- Sugestoes podem ser geradas por regras locais.
- Produto abaixo do minimo deve ser candidato a sugestao.
- Produtos inativos devem ser ignorados.
- Sugestoes devem indicar motivo.
- Usuario deve poder aceitar ou ignorar sugestao.
- Sugestoes locais devem usar regras leves e explicaveis.
- IA local pesada nao deve rodar no dispositivo.
- IA externa deve ser opcional e acionada sob demanda.

## Historico de consumo

Regra futura:

- Compras finalizadas devem alimentar historico.
- Historico deve apoiar relatorios e sugestoes.
- Dados historicos nao devem depender da existencia de estoque atual.
- Produtos inativos devem continuar visiveis em historico.
- Historico deve ser consultado por periodo, produto ou categoria para evitar carregar todo o volume.
- Relatorios devem usar agregacoes sob demanda.

## Lista de compras

Regra futura:

- Lista pode conter produtos ativos.
- Item pode ser marcado como comprado.
- Lista concluida deve poder gerar historico de compra.
- Lista nao deve alterar estoque automaticamente sem regra explicita.
- Lista de compras deve funcionar offline.
- Itens devem ser carregados por lista, nao como colecao global sem filtro.

## IA

Regra futura:

- IA externa deve ser opcional.
- App deve funcionar sem IA.
- Dados enviados para IA devem ser minimizados.
- Toda sugestao de IA deve ter fallback local ou tratamento de erro.

## Regras gerais de performance

- O app deve ser leve e performatico.
- Funcionalidades principais nao devem depender de internet.
- Consultas ao banco devem ser filtradas e objetivas.
- Duplicidades devem ser evitadas para reduzir processamento e inconsistencias.
- Dashboards e relatorios devem carregar apenas os dados necessarios para a visualizacao atual.
- Novas features devem considerar uso em smartphones simples e intermediarios.
