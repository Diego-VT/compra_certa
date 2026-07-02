import 'package:drift/drift.dart';

import '../../../../database/app_database.dart';
import '../../domain/entities/produto_entity.dart';
import '../../domain/entities/produto_filtro.dart';
import '../../domain/entities/produto_form_data.dart';
import '../../domain/entities/produto_list_item_entity.dart';

abstract class ProdutoLocalDataSource {
  Future<List<ProdutoEntity>> listarProdutos();

  Future<List<ProdutoListItemEntity>> listarProdutosParaExibicao(
    ProdutoFiltro filtro,
  );

  Future<ProdutoEntity?> buscarProdutoPorId(int id);

  Future<int> salvarProduto(ProdutoFormData produto);

  Future<void> alterarStatusProduto({required int id, required bool isAtivo});
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
  Future<List<ProdutoListItemEntity>> listarProdutosParaExibicao(
    ProdutoFiltro filtro,
  ) async {
    final query = _database.select(_database.produtos);
    final buscaNormalizada = filtro.busca.trim();

    if (buscaNormalizada.isNotEmpty) {
      query.where(
        (table) => table.nome.like(
          '%${_escapeLike(buscaNormalizada)}%',
          escapeChar: r'\',
        ),
      );
    }

    if (filtro.categoriaId != null) {
      query.where((table) => table.categoriaId.equals(filtro.categoriaId!));
    }

    switch (filtro.status) {
      case ProdutoStatusFiltro.ativos:
        query.where((table) => table.isAtivo.equals(true));
      case ProdutoStatusFiltro.inativos:
        query.where((table) => table.isAtivo.equals(false));
      case ProdutoStatusFiltro.todos:
        break;
    }

    query.orderBy([(table) => OrderingTerm.asc(table.nome)]);

    final produtos = await query.get();
    final categorias = await _database.select(_database.categorias).get();
    final categoriasPorId = {
      for (final categoria in categorias) categoria.id: categoria,
    };

    return produtos
        .map((produto) {
          final categoria = categoriasPorId[produto.categoriaId];

          return ProdutoListItemEntity(
            id: produto.id,
            nome: produto.nome,
            categoriaId: produto.categoriaId,
            categoriaNome: categoria?.nome ?? 'Categoria indisponivel',
            categoriaCaminho:
                categoria?.caminhoCompleto ?? 'Categoria indisponivel',
            unidadeMedida: produto.unidadeMedida,
            marca: produto.marca,
            quantidadeMinima: produto.quantidadeMinima,
            quantidadeIdeal: produto.quantidadeIdeal,
            isAtivo: produto.isAtivo,
          );
        })
        .toList(growable: false);
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

  @override
  Future<void> alterarStatusProduto({required int id, required bool isAtivo}) {
    return (_database.update(
      _database.produtos,
    )..where((table) => table.id.equals(id))).write(
      ProdutosCompanion(
        isAtivo: Value(isAtivo),
        atualizadoEm: Value(DateTime.now()),
      ),
    );
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

  String _escapeLike(String value) {
    return value
        .replaceAll(r'\', r'\\')
        .replaceAll('%', r'\%')
        .replaceAll('_', r'\_');
  }
}
