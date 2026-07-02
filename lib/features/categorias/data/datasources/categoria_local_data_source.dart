import 'package:drift/drift.dart';

import '../../../../database/app_database.dart';
import '../../domain/entities/categoria_entity.dart';
import '../models/categoria_seed_model.dart';

abstract class CategoriaLocalDataSource {
  Future<int> executarSeedInicial({
    required String seedKey,
    required List<CategoriaSeedModel> categorias,
  });

  Future<List<CategoriaEntity>> listarCategorias();
}

class CategoriaLocalDataSourceImpl implements CategoriaLocalDataSource {
  const CategoriaLocalDataSourceImpl(this._database);

  final AppDatabase _database;

  @override
  Future<int> executarSeedInicial({
    required String seedKey,
    required List<CategoriaSeedModel> categorias,
  }) {
    return _database.transaction(() async {
      final seedJaExecutado = await (_database.select(
        _database.seedExecutions,
      )..where((table) => table.seedKey.equals(seedKey))).getSingleOrNull();

      if (seedJaExecutado != null) {
        return 0;
      }

      var inseridas = 0;

      for (final categoria in categorias) {
        final existente =
            await (_database.select(_database.categorias)..where(
                  (table) =>
                      table.id.equals(categoria.id) |
                      table.caminhoCompleto.equals(categoria.caminhoCompleto),
                ))
                .getSingleOrNull();

        if (existente != null) {
          continue;
        }

        await _database
            .into(_database.categorias)
            .insert(
              CategoriasCompanion(
                id: Value(categoria.id),
                nome: Value(categoria.nome),
                categoriaPaiId: Value(categoria.categoriaPaiId),
                nivel: Value(categoria.nivel),
                caminhoCompleto: Value(categoria.caminhoCompleto),
                origem: Value(categoria.origem),
                isPadrao: Value(categoria.isPadrao),
                ativo: Value(categoria.ativo),
              ),
              mode: InsertMode.insertOrIgnore,
            );

        inseridas++;
      }

      await _database
          .into(_database.seedExecutions)
          .insert(
            SeedExecutionsCompanion.insert(seedKey: seedKey),
            mode: InsertMode.insertOrIgnore,
          );

      return inseridas;
    });
  }

  @override
  Future<List<CategoriaEntity>> listarCategorias() async {
    final rows =
        await (_database.select(_database.categorias)..orderBy([
              (table) => OrderingTerm.asc(table.nivel),
              (table) => OrderingTerm.asc(table.caminhoCompleto),
            ]))
            .get();

    return rows
        .map(
          (row) => CategoriaEntity(
            id: row.id,
            nome: row.nome,
            categoriaPaiId: row.categoriaPaiId,
            nivel: row.nivel,
            caminhoCompleto: row.caminhoCompleto,
            origem: row.origem,
            isPadrao: row.isPadrao,
            ativo: row.ativo,
          ),
        )
        .toList(growable: false);
  }
}
