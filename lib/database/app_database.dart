import 'package:drift/drift.dart';

import 'database_connection.dart';

part 'app_database.g.dart';

class Categorias extends Table {
  IntColumn get id => integer()();
  TextColumn get nome => text()();
  IntColumn get categoriaPaiId => integer().nullable()();
  IntColumn get nivel => integer()();
  TextColumn get caminhoCompleto => text().unique()();
  TextColumn get origem => text()();
  BoolColumn get isPadrao => boolean().withDefault(const Constant(true))();
  BoolColumn get ativo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get criadoEm => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get atualizadoEm => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class SeedExecutions extends Table {
  TextColumn get seedKey => text()();
  DateTimeColumn get executadoEm =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {seedKey};
}

class Produtos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
  IntColumn get categoriaId => integer().references(Categorias, #id)();
  TextColumn get unidadeMedida => text()();
  TextColumn get marca => text().nullable()();
  RealColumn get quantidadeMinima => real().withDefault(const Constant(0))();
  RealColumn get quantidadeIdeal => real().withDefault(const Constant(0))();
  TextColumn get observacoes => text().nullable()();
  BoolColumn get isAtivo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get criadoEm => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get atualizadoEm => dateTime().nullable()();
}

class Estoques extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get produtoId => integer().references(Produtos, #id).unique()();
  RealColumn get quantidadeAtual => real().withDefault(const Constant(0))();
  DateTimeColumn get atualizadoEm =>
      dateTime().withDefault(currentDateAndTime)();
}

class MovimentacoesEstoque extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get produtoId => integer().references(Produtos, #id)();
  TextColumn get tipo => text()();
  RealColumn get quantidade => real()();
  RealColumn get quantidadeAnterior => real()();
  RealColumn get quantidadeFinal => real()();
  TextColumn get motivo => text().nullable()();
  DateTimeColumn get criadoEm => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(
  tables: [
    Categorias,
    SeedExecutions,
    Produtos,
    Estoques,
    MovimentacoesEstoque,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (migrator, from, to) async {
        if (from < 2) {
          await migrator.createTable(produtos);
        }
        if (from < 3) {
          await migrator.createTable(estoques);
          await migrator.createTable(movimentacoesEstoque);
        }
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}
