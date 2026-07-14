# Modelo de Dados - CompraCerta

## Visao geral

O banco local do CompraCerta usa Drift/SQLite. O modelo atual cobre categorias, produtos, controle de seeds, estoque, movimentacoes de estoque, historico de compras e listas de compras. O modelo futuro prepara sugestoes inteligentes.

Schema atual: `5`.

A Sprint 09 inicia o Motor Inteligente Local sem alteracao de schema. As sugestoes sao calculadas sob demanda a partir de estoque, produtos ativos e historico de compras.

## Tabelas atuais

## `categorias`

### Justificativa

Organizar produtos em hierarquia e servir como base para filtros, relatorios e sugestoes futuras.

### Campos

| Campo | Tipo | Descricao |
| --- | --- | --- |
| `id` | inteiro | Chave primaria. |
| `nome` | texto | Nome da categoria. |
| `categoriaPaiId` | inteiro nullable | Categoria pai. |
| `nivel` | inteiro | Nivel na hierarquia. |
| `caminhoCompleto` | texto unico | Caminho hierarquico completo. |
| `origem` | texto | Origem do cadastro ou seed. |
| `isPadrao` | booleano | Indica categoria padrao. |
| `ativo` | booleano | Indica categoria ativa. |
| `criadoEm` | data/hora | Criacao. |
| `atualizadoEm` | data/hora nullable | Ultima alteracao. |

### Relacionamentos

- `categoriaPaiId` aponta logicamente para `categorias.id`.
- `produtos.categoriaId` referencia `categorias.id`.

## `seed_executions`

### Justificativa

Registrar seeds executados para evitar duplicidade.

### Campos

| Campo | Tipo | Descricao |
| --- | --- | --- |
| `seedKey` | texto | Chave primaria do seed. |
| `executadoEm` | data/hora | Data de execucao. |

## `produtos`

### Justificativa

Representar itens que o usuario acompanha para compras, estoque e historico.

### Campos

| Campo | Tipo | Descricao |
| --- | --- | --- |
| `id` | inteiro auto incrementado | Chave primaria. |
| `nome` | texto | Nome do produto. |
| `categoriaId` | inteiro | Categoria vinculada. |
| `unidadeMedida` | texto | Unidade de controle. |
| `marca` | texto nullable | Marca. |
| `quantidadeMinima` | real | Quantidade minima desejada. |
| `quantidadeIdeal` | real | Quantidade ideal desejada. |
| `observacoes` | texto nullable | Observacoes. |
| `isAtivo` | booleano | Status logico. |
| `criadoEm` | data/hora | Criacao. |
| `atualizadoEm` | data/hora nullable | Ultima alteracao. |

### Relacionamentos

- `categoriaId` referencia `categorias.id`.

## `estoques`

### Justificativa

Controlar a quantidade atual de cada produto de forma local e offline.

### Campos

| Campo | Tipo | Descricao |
| --- | --- | --- |
| `id` | inteiro auto incrementado | Chave primaria. |
| `produtoId` | inteiro unico | Produto vinculado. |
| `quantidadeAtual` | real | Quantidade atual em estoque. |
| `atualizadoEm` | data/hora | Ultima atualizacao do saldo. |

### Relacionamentos

- `produtoId` referencia `produtos.id`.

## `movimentacoes_estoque`

### Justificativa

Registrar entradas, saidas e ajustes de estoque para auditoria e evolucao futura do historico.

### Campos

| Campo | Tipo | Descricao |
| --- | --- | --- |
| `id` | inteiro auto incrementado | Chave primaria. |
| `produtoId` | inteiro | Produto movimentado. |
| `tipo` | texto | Tipo da movimentacao: entrada, saida ou ajuste. |
| `quantidade` | real | Quantidade informada na movimentacao. |
| `quantidadeAnterior` | real | Saldo antes da movimentacao. |
| `quantidadeFinal` | real | Saldo apos a movimentacao. |
| `motivo` | texto nullable | Motivo ou observacao opcional. |
| `criadoEm` | data/hora | Data de criacao da movimentacao. |

### Relacionamentos

- `produtoId` referencia `produtos.id`.

## `compras`

### Justificativa

Registrar compras realizadas para consulta historica e evolucao futura de relatorios e sugestoes.

### Campos

| Campo | Tipo | Descricao |
| --- | --- | --- |
| `id` | inteiro auto incrementado | Chave primaria. |
| `dataCompra` | data/hora | Data em que a compra foi realizada. |
| `observacoes` | texto nullable | Observacoes livres da compra. |
| `criadoEm` | data/hora | Data de criacao do registro. |

### Relacionamentos

- `itens_compra.compraId` referencia `compras.id`.

### Indices

- `idx_compras_data_compra_id` otimiza consultas de historico por data e ordenacao incremental.

## `itens_compra`

### Justificativa

Registrar os produtos, quantidades e valores opcionais de cada compra.

### Campos

| Campo | Tipo | Descricao |
| --- | --- | --- |
| `id` | inteiro auto incrementado | Chave primaria. |
| `compraId` | inteiro | Compra vinculada. |
| `produtoId` | inteiro | Produto comprado. |
| `quantidade` | real | Quantidade comprada. |
| `valorUnitario` | real nullable | Valor unitario informado, quando existir. |

### Relacionamentos

- `compraId` referencia `compras.id`.
- `produtoId` referencia `produtos.id`.

### Indices

- `idx_itens_compra_compra_id` otimiza carregamento dos itens de uma compra.
- `idx_itens_compra_produto_id` prepara consultas historicas por produto.

## `listas_compras`

### Justificativa

Planejar compras futuras e acompanhar itens comprados sem depender de internet.

### Campos

| Campo | Tipo | Descricao |
| --- | --- | --- |
| `id` | inteiro auto incrementado | Chave primaria. |
| `nome` | texto | Nome da lista. |
| `status` | texto | Status da lista: `aberta` ou `concluida`. |
| `criadoEm` | data/hora | Data de criacao. |
| `atualizadoEm` | data/hora nullable | Ultima alteracao. |
| `concluidoEm` | data/hora nullable | Data de conclusao futura. |

### Relacionamentos

- `itens_lista_compras.listaCompraId` referencia `listas_compras.id`.

### Indices

- `idx_listas_compras_status_id` otimiza consultas por status e carregamento incremental.

## `itens_lista_compras`

### Justificativa

Registrar produtos planejados, quantidade desejada e marcacao de compra.

### Campos

| Campo | Tipo | Descricao |
| --- | --- | --- |
| `id` | inteiro auto incrementado | Chave primaria. |
| `listaCompraId` | inteiro | Lista vinculada. |
| `produtoId` | inteiro | Produto planejado. |
| `quantidadePlanejada` | real | Quantidade desejada. |
| `quantidadeComprada` | real | Quantidade efetivamente comprada. |
| `isComprado` | booleano | Indica item marcado como comprado. |
| `observacoes` | texto nullable | Observacoes do item. |
| `criadoEm` | data/hora | Data de criacao. |
| `atualizadoEm` | data/hora nullable | Ultima alteracao. |

### Relacionamentos

- `listaCompraId` referencia `listas_compras.id`.
- `produtoId` referencia `produtos.id`.

### Indices

- `idx_itens_lista_compras_lista_id` otimiza carregamento dos itens de uma lista.
- `idx_itens_lista_compras_produto_id` prepara consultas por produto.
- `idx_itens_lista_compras_lista_produto` evita duplicidade do mesmo produto na mesma lista.

## Tabelas futuras

## `sugestoes_inteligentes`

Sugestoes geradas por regras locais ou IA. A tabela permanece futura; a primeira implementacao do motor local nao persiste sugestoes para evitar migration prematura.

Campos previstos:

- `id`
- `tipo`
- `origem`
- `descricao`
- `dadosContexto`
- `status`
- `criadoEm`
- `resolvidoEm`

## `preferencias_notificacoes`

Preferencias futuras para notificacoes locais.

Campos previstos:

- `id`
- `tipo`
- `isAtivo`
- `horarioPreferido`
- `criadoEm`
- `atualizadoEm`

## Preparacao para recursos inteligentes

O modelo atual permite evoluir para inteligencia por:

- categorias hierarquicas;
- produtos ativos/inativos;
- minimo e ideal por produto;
- saldo atual por produto;
- movimentacoes auditaveis de estoque;
- historico de compras;
- listas de compras offline;
- sugestoes auditaveis.
- preferencias locais para notificacoes.

## Relatorios

A Sprint 11 inicia relatorios sem alteracao de schema. Os relatorios leem `compras`, `itens_compra`, `produtos` e `categorias` com consultas agregadas sob demanda.
