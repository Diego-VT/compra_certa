import 'package:drift/drift.dart';

import '../../../../database/app_database.dart';
import '../../domain/entities/produto_entity.dart';
import '../../domain/entities/produto_form_data.dart';

abstract class ProdutoLocalDataSource {
  Future<List<ProdutoEntity>> listarProdutos();

  Future<ProdutoEntity?> buscarProdutoPorId(int id);

  Future<int> salvarProduto(ProdutoFormData produto);
}

class ProdutoLocalDataSourceImpl implements ProdutoLocalDataSource {
  const ProdutoLocalDataSourceImpl(this._database);

  final AppDatabase _database;

  @override
  Future<List<ProdutoEntity>> listarProdutos() async {
    final rows = await (_database.select(
      _database.produtos,
    )..orderBy([(table) => OrderingTerm.asc(table.nome)])).get();

    return rows.map(_mapRow).toList(growable: false);
  }

  @override
  Future<ProdutoEntity?> buscarProdutoPorId(int id) async {
    final row = await (_database.select(
      _database.produtos,
    )..where((table) => table.id.equals(id))).getSingleOrNull();

    if (row == null) {
      return null;
    }

    return _mapRow(row);
  }

  @override
  Future<int> salvarProduto(ProdutoFormData produto) async {
    final companion = ProdutosCompanion(
      nome: Value(produto.nome.trim()),
      categoriaId: Value(produto.categoriaId),
      unidadeMedida: Value(produto.unidadeMedida.trim()),
      marca: Value(_emptyToNull(produto.marca)),
      quantidadeMinima: Value(produto.quantidadeMinima),
      quantidadeIdeal: Value(produto.quantidadeIdeal),
      observacoes: Value(_emptyToNull(produto.observacoes)),
      isAtivo: Value(produto.isAtivo),
      atualizadoEm: Value(DateTime.now()),
    );

    if (produto.id == null) {
      return _database.into(_database.produtos).insert(companion);
    }

    await (_database.update(
      _database.produtos,
    )..where((table) => table.id.equals(produto.id!))).write(companion);

    return produto.id!;
  }

  ProdutoEntity _mapRow(Produto row) {
    return ProdutoEntity(
      id: row.id,
      nome: row.nome,
      categoriaId: row.categoriaId,
      unidadeMedida: row.unidadeMedida,
      marca: row.marca,
      quantidadeMinima: row.quantidadeMinima,
      quantidadeIdeal: row.quantidadeIdeal,
      observacoes: row.observacoes,
      isAtivo: row.isAtivo,
      criadoEm: row.criadoEm,
      atualizadoEm: row.atualizadoEm,
    );
  }

  String? _emptyToNull(String? value) {
    final normalized = value?.trim();

    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    return normalized;
  }
}
