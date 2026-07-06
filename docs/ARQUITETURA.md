# Arquitetura - CompraCerta

## Visao geral

O CompraCerta usa Clean Architecture modular por feature. A UI, o estado, as regras de negocio e a persistencia ficam separados para permitir evolucao segura.

## Tecnologias

- Flutter.
- Dart.
- Riverpod.
- Go Router.
- Drift/SQLite.
- Material Design 3.

## Estrutura principal

```text
lib/
  app/
  core/
  database/
  features/
  services/
  shared/
  main.dart
```

## Organizacao da documentacao

A documentacao oficial fica distribuida entre arquivos de governanca na raiz e documentos tecnicos em `docs/`.

```text
docs/
  arquitetura/
  banco/
  negocio/
  sprints/
  releases/
  api/
  wireframes/
  prototipos/
  testes/
  imagens/
  processos/
```

Os arquivos principais permanecem em `docs/` para manter compatibilidade com referencias existentes. As subpastas documentam areas especificas e devem receber materiais detalhados conforme o projeto evoluir.

## Responsabilidades

### `app/`

Composicao da aplicacao, incluindo `MaterialApp.router`, temas e router.

### `core/`

Infraestrutura compartilhada:

- DI global.
- Erros.
- Router.
- Tema.

### `database/`

Configuracao Drift/SQLite:

- tabelas;
- conexao;
- migrations;
- codigo gerado.

### `features/`

Modulos funcionais independentes.

Atuais:

- `categorias`
- `produtos`
- `bootstrap`
- `estoque`
- `compras`
- `listas_compras`
- `inteligencia`

### `services/`

Servicos externos ou de plataforma futuros.

### `shared/`

Widgets, extensoes e utilitarios compartilhados.

## Padrao por feature

```text
feature/
  application/
  data/
    datasources/
    models/
    repositories/
  domain/
    entities/
    repositories/
    usecases/
  presentation/
    pages/
    widgets/
```

## Clean Architecture

### Domain

Contem entidades, contratos e usecases. Nao deve depender de Flutter, Drift ou UI.

Na feature `inteligencia`, o calculo de quantidade sugerida, motivo e explicacao fica em servico de dominio para manter as regras locais testaveis sem acoplamento ao banco.

### Data

Contem datasources e implementacoes concretas de repositories.

### Application

Contem providers Riverpod e orquestracao de estado.

### Presentation

Contem telas e widgets.

## Repository Pattern

Repositories sao contratos no dominio e implementacoes em data.

Beneficios:

- facilita testes;
- desacopla UI do banco;
- permite trocar fonte de dados;
- organiza regras de acesso a dados.

## Riverpod

Usado para:

- injecao de dependencia;
- estado assincromo;
- filtros;
- conexao entre UI e usecases.

Padroes:

- `Provider` para datasources, repositories e usecases.
- `FutureProvider` para consultas.
- `StateProvider` para estado simples de tela.

## Go Router

Rotas atuais:

```text
/
/categorias
/produtos
/produtos/novo
/produtos/:id/editar
/estoque
/estoque/:produtoId/ajustar
/compras
/compras/nova
/compras/:id
/sugestoes
/listas-compras
/listas-compras/nova
/listas-compras/:id
```

Boas praticas:

- usar `AppRoute`;
- evitar strings soltas;
- centralizar rotas em `core/router`.

## Drift/SQLite

Drift e usado para persistencia local tipada.

Tabelas atuais:

- `categorias`
- `produtos`
- `seed_executions`
- `estoques`
- `movimentacoes_estoque`
- `compras`
- `itens_compra`
- `listas_compras`
- `itens_lista_compras`

Schema atual: `5`.

Boas praticas:

- atualizar `schemaVersion` ao mudar tabelas;
- criar migration;
- regenerar codigo;
- testar com banco em memoria.

## Performance

Performance e uma diretriz arquitetural obrigatoria. O app deve permanecer leve, responsivo e adequado para smartphones simples e intermediarios.

Principios:

- Evitar carregar colecoes grandes inteiras na memoria.
- Usar paginacao, filtros ou busca sob demanda quando o volume de dados crescer.
- Evitar consultas sem filtro em fluxos com potencial de muitos registros.
- Criar indices no banco quando filtros frequentes justificarem.
- Manter logica pesada fora da camada de interface.
- Evitar widgets gigantes; dividir composicoes complexas.
- Evitar dependencias que aumentem tamanho, custo de build ou consumo em runtime sem necessidade clara.
- Evitar uso excessivo de imagens e assets pesados.
- Manter funcoes principais offline: cadastro, produtos, categorias, estoque e lista de compras.
- Carregar historico, dashboard e relatorios sob demanda.
- Gerar sugestoes inteligentes locais sob demanda, sem processamento continuo em segundo plano.

Critérios de performance:

- Tela inicial deve abrir rapidamente.
- Listagens devem migrar para carregamento incremental quando houver muitos registros.
- Categorias devem poder ser consultadas por nivel, busca ou filtro.
- Busca de produtos nao deve travar a interface.
- Banco local deve evitar duplicidades e consultas desnecessarias.
- IA local pesada nao deve ser executada no dispositivo.
- IA externa deve ser opcional e acionada apenas sob demanda.

## Material Design 3

O projeto usa `useMaterial3: true`, `ColorScheme.fromSeed`, tema claro, tema escuro e `ThemeMode.system`.

## Boas praticas

- Manter UI sem regras de negocio.
- Manter dominio independente.
- Testar regras novas.
- Evitar exclusao fisica quando historico for relevante.
- Avaliar impacto de performance antes de adicionar novas dependencias ou consultas.
- Atualizar docs ao mudar arquitetura ou dados.
- Rodar `flutter analyze` e `flutter test` antes de concluir.
