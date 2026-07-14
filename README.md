# CompraCerta

Aplicativo Flutter preparado para evoluir como uma solucao de apoio a compras, organizacao de itens e modulos inteligentes futuros.

O projeto ja possui base profissional, documentacao de governanca, modulo de Categorias, modulo de Produtos, modulo de Estoque, Historico de Compras, Lista de Compras, Dashboard, Motor Inteligente Local, camada opcional de IA externa por contrato e Relatorios. A IA externa fica desativada por padrao, usa prompt versionado, sanitizacao de contexto, acionamento manual e fallback local.

## Documentacao oficial

O CompraCerta possui documentacao de produto, arquitetura, governanca e processo para orientar desenvolvimento humano e colaboracao com agentes de IA.

Documentos principais na raiz:

- `PRODUCT_VISION.md`: visao executiva, missao, valores e objetivos.
- `PRODUCT_BACKLOG.md`: backlog organizado por epic, feature, user story, task e subtask.
- `USER_STORIES.md`: historias de usuario no padrao Scrum.
- `MVP.md`: escopo do MVP e evolucao por versao.
- `PROJECT_BOARD.md`: quadro Kanban textual.
- `MILESTONES.md`: marcos do projeto.
- `ROADMAP.md`: sprints, status e evolucao tecnica.
- `AGENTS.md`: regras para agentes de IA.
- `CONTRIBUTING.md`: fluxo de contribuicao.
- `DECISIONS.md`: decisoes arquiteturais.
- `CHANGELOG.md`: historico tecnico no padrao Keep a Changelog.
- `RELEASE_NOTES.md`: notas amigaveis de release.
- `VERSIONING.md`: estrategia de versionamento semantico.
- `SECURITY.md`: seguranca, privacidade e LGPD.
- `TECH_DEBT.md`: registro de dividas tecnicas.
- `UI_UX_GUIDELINES.md`: diretrizes de interface e experiencia.
- `CODE_STYLE.md`: padroes oficiais de codigo.

Documentos principais em `docs/`:

- `docs/PRD.md`: requisitos de produto.
- `docs/ARQUITETURA.md`: arquitetura e padroes.
- `docs/MODELO_DADOS.md`: tabelas atuais e futuras.
- `docs/REGRAS_NEGOCIO.md`: regras atuais e planejadas.
- `docs/PLANO_TESTES.md`: estrategia de testes.
- `docs/PRODUCT_STRATEGY.md`: estrategia, personas e jornada.
- `docs/NON_FUNCTIONAL_REQUIREMENTS.md`: requisitos nao funcionais.
- `docs/RELEASE_PROCESS.md`: processo oficial de release.
- `docs/sprints/`: planejamento das proximas sprints.

## Tecnologias

- Flutter 3.44.2
- Dart 3.12.2
- Material Design 3
- Riverpod para estado e injecao de dependencia
- Go Router para navegacao declarativa
- Drift com SQLite para persistencia local
- Build Runner e Drift Dev para geracao de codigo

## Arquitetura

O projeto usa Clean Architecture modular por feature.

Camadas previstas por feature:

- `domain`: entidades, contratos de repositorio e casos de uso.
- `data`: datasources, DTOs, mappers e implementacoes de repositorio.
- `application`: providers, controllers e orquestracao de casos de uso.
- `presentation`: paginas, widgets e componentes especificos da interface.

Riverpod atua como container de injecao de dependencia e gerenciador de estado. Go Router centraliza rotas e prepara o app para guards e deep links. Drift fica isolado em `database/` para que o banco local nao contamine a UI nem as regras de negocio.

## Modulo de categorias

O primeiro modulo real do projeto e `features/categorias`.

Decisoes importantes:

- As categorias iniciais sao carregadas do asset `assets/seeds/categorias_seed_compra_certa.json`.
- O seed e controlado pela tabela `seed_executions`, evitando reimportacao em execucoes futuras.
- A tabela `categorias` usa `id` como chave primaria e `caminhoCompleto` como valor unico, reduzindo risco de duplicidade.
- A hierarquia e mantida pelo campo `categoriaPaiId`.
- A insercao usa `insertOrIgnore` dentro de transacao para preservar dados existentes.
- O modulo segue Repository Pattern com datasource local, datasource de asset, repository, usecases e providers Riverpod.

## Modulo de produtos

O modulo `features/produtos` implementa o cadastro inicial de produtos.

Decisoes importantes:

- Cada produto referencia uma categoria existente por `categoriaId`.
- O banco local usa a tabela `produtos` no Drift/SQLite.
- O cadastro usa Repository Pattern com datasource local, repository, usecases e providers Riverpod.
- A tela de formulario valida nome, categoria, unidade de medida e quantidades numericas.
- A listagem permite busca por nome, filtro por categoria e filtro por status.
- Produtos nao sao removidos fisicamente; a ativacao/desativacao usa exclusao logica por `isAtivo`.
- A listagem permite acesso ao modulo de estoque.
- Esta etapa nao implementa lista de compras ou inteligencia artificial.

## Modulo de estoque

O modulo `features/estoque` implementa o controle inicial de quantidade atual por produto.

Decisoes importantes:

- O banco local usa as tabelas `estoques` e `movimentacoes_estoque`.
- Cada produto possui no maximo um saldo atual em `estoques`.
- Toda entrada, saida ou ajuste gera registro em `movimentacoes_estoque`.
- Saidas nao podem deixar o estoque negativo.
- Produtos inativos nao recebem movimentacao operacional na Sprint 05.
- Produtos ativos abaixo da quantidade minima sao identificados para reposicao futura.
- A tela de estoque permite alternar entre todos os produtos e apenas itens abaixo do minimo.
- O modulo segue Repository Pattern com datasource local, repository, usecases e providers Riverpod.

## Modulo de historico de compras

O modulo `features/compras` implementa o registro e a consulta de compras realizadas.

Decisoes importantes:

- O banco local usa as tabelas `compras` e `itens_compra`.
- Cada compra possui data, observacoes opcionais e um ou mais itens.
- Cada item referencia um produto existente e ativo no momento do registro.
- A tela de historico permite filtro por periodo e carregamento incremental.
- A paginacao usa ordenacao estavel por data e id.
- Indices locais otimizam consultas por data, compra e produto.
- O modulo segue Repository Pattern com datasource local, repository, usecases e providers Riverpod.

## Modulo de lista de compras

O modulo `features/listas_compras` implementa listas planejadas de compras.

Decisoes importantes:

- O banco local usa as tabelas `listas_compras` e `itens_lista_compras`.
- Lista funciona offline e pode conter produtos ativos.
- A tela de listas permite filtro por status e carregamento incremental.
- A tela de detalhe permite adicionar itens e marcar itens comprados.
- A geracao por estoque baixo considera produtos ativos abaixo do minimo e pede confirmacao do usuario.
- O mesmo produto nao pode ser duplicado na mesma lista.
- O modulo segue Repository Pattern com datasource local, repository, usecases e providers Riverpod.

## Modulo de dashboard

O modulo `features/dashboard` implementa a tela inicial com resumo operacional do app.

Decisoes importantes:

- O dashboard e a rota inicial do aplicativo.
- Os indicadores sao carregados sob demanda a partir dos modulos de estoque, listas de compras e historico.
- A tela destaca produtos abaixo do minimo, listas abertas e compras recentes.
- A navegacao contextual permite acessar rapidamente estoque, listas de compras e historico.
- O modulo segue Repository Pattern com repository, usecase e providers Riverpod.

## Modulo de relatorios

O modulo `features/relatorios` inicia a analise de compras e consumo por periodo.

Decisoes importantes:

- Os relatorios sao carregados sob demanda.
- As consultas usam agregacoes no banco local, sem carregar todo o historico na memoria.
- A tela inicial exibe resumo do periodo, produtos mais comprados e consumo por categoria.
- O modulo nao altera o schema Drift/SQLite nesta etapa.
- Exportacao permanece preparada como evolucao futura.
- O modulo segue Repository Pattern com datasource local, repository, usecase e providers Riverpod.

## Estrutura de pastas

```text
lib/
  app/
    compra_certa_app.dart
  core/
    di/
    errors/
    router/
    theme/
  database/
    app_database.dart
    app_database.g.dart
    database_connection.dart
    database_connection_io.dart
    database_connection_stub.dart
  features/
    _feature_template/
    bootstrap/
      application/
      data/
      domain/
      presentation/
    categorias/
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
    produtos/
      application/
      data/
        datasources/
        repositories/
      domain/
        entities/
        repositories/
        usecases/
      presentation/
        pages/
    compras/
      application/
      data/
        datasources/
        repositories/
      domain/
        entities/
        repositories/
        usecases/
      presentation/
        pages/
    dashboard/
      application/
      data/
        repositories/
      domain/
        entities/
        repositories/
        usecases/
      presentation/
        pages/
    inteligencia/
      application/
      data/
        datasources/
        repositories/
      domain/
        entities/
        repositories/
        usecases/
      presentation/
        pages/
    listas_compras/
      application/
      data/
        datasources/
        repositories/
      domain/
        entities/
        repositories/
        usecases/
      presentation/
        pages/
    relatorios/
      application/
      data/
        datasources/
        repositories/
      domain/
        entities/
        repositories/
        usecases/
      presentation/
        pages/
    estoque/
      application/
      data/
        datasources/
        repositories/
      domain/
        entities/
        repositories/
        usecases/
      presentation/
        pages/
  assets/
    seeds/
      categorias_seed_compra_certa.json
  services/
  shared/
    extensions/
    widgets/
  main.dart
```

## Comandos executados

```bash
C:\develop\flutter\bin\flutter.bat doctor -v
C:\develop\flutter\bin\flutter.bat create --project-name compra_certa compra_certa
C:\develop\flutter\bin\flutter.bat pub add flutter_riverpod go_router drift sqlite3_flutter_libs path path_provider dev:drift_dev dev:build_runner
C:\develop\flutter\bin\cache\dart-sdk\bin\dart.exe format lib test
C:\develop\flutter\bin\cache\dart-sdk\bin\dart.exe run build_runner build
C:\develop\flutter\bin\cache\dart-sdk\bin\dart.exe run build_runner build --delete-conflicting-outputs
C:\develop\flutter\bin\flutter.bat pub get
C:\develop\flutter\bin\flutter.bat analyze
C:\develop\flutter\bin\flutter.bat test
```

## Comandos uteis

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter run
```

## Pendencias de ambiente

O `flutter doctor` encontrou os seguintes pontos:

- `flutter` e `dart` nao estao no PATH do sistema. O SDK foi usado diretamente em `C:\develop\flutter\bin\flutter.bat`.
- Visual Studio nao esta instalado, entao desenvolvimento para Windows desktop nao esta pronto.
- O Flutter informou que o Developer Mode do Windows precisa ser habilitado para builds com plugins que usam symlinks.

Android SDK, licencas Android, Chrome e recursos de rede foram reconhecidos corretamente.

## Proximos passos

1. Habilitar Developer Mode no Windows.
2. Rodar `flutter pub get` novamente apos habilitar Developer Mode.
3. Resolver a verificacao SSH do GitHub para voltar a usar o remoto SSH.
4. Iniciar Sprint 12 - Notificacoes conforme documentacao oficial.
5. Planejar estrategia de testes de release para o marco `1.0.0`.
6. Manter entidades, contratos e casos de uso antes das telas nas proximas features.
