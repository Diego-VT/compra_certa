# Modelo de Dados - CompraCerta

## Visao geral

O banco local do CompraCerta usa Drift/SQLite. O modelo atual cobre categorias, produtos, controle de seeds, estoque, movimentacoes de estoque e historico de compras. O modelo futuro prepara listas e sugestoes inteligentes.

Schema atual: `4`.

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

## Tabelas futuras

## `listas_compras`

Listas planejadas de compras.

Campos previstos:

- `id`
- `nome`
- `status`
- `criadoEm`
- `concluidoEm`

## `itens_lista_compras`

Itens planejados em uma lista.

Campos previstos:

- `id`
- `listaCompraId`
- `produtoId`
- `quantidadePlanejada`
- `quantidadeComprada`
- `isComprado`
- `observacoes`

## `sugestoes_inteligentes`

Sugestoes geradas por regras locais ou IA.

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
- historico futuro de compras;
- sugestoes auditaveis.
- preferencias locais para notificacoes.
