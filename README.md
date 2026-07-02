# CompraCerta

Aplicativo Flutter preparado para evoluir como uma solucao de apoio a compras, organizacao de itens e modulos inteligentes futuros.

Esta etapa cria apenas a base profissional do projeto. Nenhuma funcionalidade de cadastro, estoque, lista de compras ou inteligencia artificial foi implementada.

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
- Esta etapa nao implementa estoque, lista de compras ou inteligencia artificial.

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
3. Rodar `dart run build_runner build --delete-conflicting-outputs` quando as primeiras tabelas Drift forem criadas.
4. Definir os modulos iniciais do dominio.
5. Criar entidades, contratos e casos de uso antes das telas.
6. Implementar telas apenas depois das regras e contratos principais estarem claros.
