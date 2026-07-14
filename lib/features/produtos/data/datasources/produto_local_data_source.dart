import 'package:drift/drift.dart';

import '../../../../database/app_database.dart';
import '../../domain/entities/produto_entity.dart';
import '../../domain/entities/produto_filtro.dart';
import '../../domain/entities/produto_form_data.dart';
import '../../domain/entities/produto_list_item_entity.dart';
import '../models/produto_seed_model.dart';

abstract class ProdutoLocalDataSource {
  Future<int> executarSeedInicial({
    required String seedKey,
    required List<ProdutoSeedModel> produtos,
  });

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
  Future<int> executarSeedInicial({
    required String seedKey,
    required List<ProdutoSeedModel> produtos,
  }) {
    return _database.transaction(() async {
      final seedJaExecutado = await (_database.select(
        _database.seedExecutions,
      )..where((table) => table.seedKey.equals(seedKey))).getSingleOrNull();

      if (seedJaExecutado != null) {
        return 0;
      }

      var inseridos = 0;

      for (final produto in produtos) {
        final categoria = await (_database.select(_database.categorias)..where(
              (table) => table.id.equals(produto.categoriaId),
            ))
            .getSingleOrNull();

        if (categoria == null) {
          continue;
        }

        final existente =
            await (_database.select(_database.produtos)..where(
                  (table) =>
                      table.nome.equals(produto.nome) &
                      table.categoriaId.equals(produto.categoriaId),
                ))
                .getSingleOrNull();

        if (existente != null) {
          continue;
        }

        await _database
            .into(_database.produtos)
            .insert(
              ProdutosCompanion.insert(
                nome: produto.nome.trim(),
                categoriaId: produto.categoriaId,
                unidadeMedida: produto.unidadeMedida.trim(),
                marca: Value(_emptyToNull(produto.marca)),
                quantidadeMinima: Value(produto.quantidadeMinima),
                quantidadeIdeal: Value(produto.quantidadeIdeal),
                observacoes: Value(_emptyToNull(produto.observacoes)),
                isAtivo: Value(produto.isAtivo),
              ),
            );

        inseridos++;
      }

      await _database
          .into(_database.seedExecutions)
          .insert(
            SeedExecutionsCompanion.insert(seedKey: seedKey),
            mode: InsertMode.insertOrIgnore,
          );

      return inseridos;
    });
  }

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
    final busca = _ProdutoBusca.from(filtro.busca);
    final categorias = await _database.select(_database.categorias).get();
    final categoriasPorId = {
      for (final categoria in categorias) categoria.id: categoria,
    };

    if (filtro.categoriaId != null) {
      final categoriaIds = _categoriaComDescendentes(
        filtro.categoriaId!,
        categorias,
      );
      query.where((table) => table.categoriaId.isIn(categoriaIds));
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

    final itens = produtos
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
            observacoes: produto.observacoes,
          );
        })
        .where((produto) => _correspondeBusca(produto, busca))
        .toList()
      ..sort((a, b) => _compararProdutos(a, b, busca));

    return itens;
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

  bool _correspondeBusca(ProdutoListItemEntity produto, _ProdutoBusca busca) {
    if (busca.isEmpty) {
      return true;
    }

    if (busca.exigeTextoLiteral &&
        !_textoLiteralProduto(produto).contains(busca.textoLiteral)) {
      return false;
    }

    final textoBusca = _textoBuscaProduto(produto);

    return busca.termos.every(textoBusca.contains);
  }

  int _compararProdutos(
    ProdutoListItemEntity a,
    ProdutoListItemEntity b,
    _ProdutoBusca busca,
  ) {
    if (!busca.isEmpty) {
      final scoreCompare =
          _scoreBusca(b, busca.termos).compareTo(_scoreBusca(a, busca.termos));

      if (scoreCompare != 0) {
        return scoreCompare;
      }
    }

    final categoriaCompare = a.categoriaCaminho.compareTo(b.categoriaCaminho);

    if (categoriaCompare != 0) {
      return categoriaCompare;
    }

    return a.nome.compareTo(b.nome);
  }

  int _scoreBusca(ProdutoListItemEntity produto, List<String> termos) {
    final nome = _normalizarTexto(produto.nome);
    final marca = _normalizarTexto(produto.marca ?? '');
    final categoria = _normalizarTexto(produto.categoriaCaminho);
    final unidade = _normalizarTexto(produto.unidadeMedida);
    final textoBusca = _textoBuscaProduto(produto);
    var score = 0;

    for (final termo in termos) {
      if (nome == termo) {
        score += 50;
      } else if (nome.startsWith(termo)) {
        score += 30;
      } else if (nome.contains(termo)) {
        score += 20;
      }

      if (marca.contains(termo)) {
        score += 12;
      }

      if (categoria.contains(termo)) {
        score += 8;
      }

      if (unidade.contains(termo)) {
        score += 4;
      }

      if (textoBusca.contains(termo)) {
        score += 1;
      }
    }

    return score;
  }

  String _textoBuscaProduto(ProdutoListItemEntity produto) {
    return _normalizarTexto(
      [
        produto.nome,
        produto.marca,
        produto.unidadeMedida,
        produto.categoriaNome,
        produto.categoriaCaminho,
        produto.observacoes,
      ].whereType<String>().join(' '),
    );
  }

  String _textoLiteralProduto(ProdutoListItemEntity produto) {
    return [
      produto.nome,
      produto.marca,
      produto.unidadeMedida,
      produto.categoriaNome,
      produto.categoriaCaminho,
      produto.observacoes,
    ].whereType<String>().join(' ').toLowerCase();
  }

  String _normalizarTexto(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[áàâãä]'), 'a')
        .replaceAll(RegExp(r'[éèêë]'), 'e')
        .replaceAll(RegExp(r'[íìîï]'), 'i')
        .replaceAll(RegExp(r'[óòôõö]'), 'o')
        .replaceAll(RegExp(r'[úùûü]'), 'u')
        .replaceAll('ç', 'c')
        .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  List<int> _categoriaComDescendentes(
    int categoriaId,
    List<Categoria> categorias,
  ) {
    final filhosPorPai = <int, List<Categoria>>{};

    for (final categoria in categorias) {
      final paiId = categoria.categoriaPaiId;

      if (paiId == null) {
        continue;
      }

      filhosPorPai.putIfAbsent(paiId, () => []).add(categoria);
    }

    final resultado = <int>{categoriaId};
    final pendentes = <int>[categoriaId];

    while (pendentes.isNotEmpty) {
      final atual = pendentes.removeLast();
      final filhos = filhosPorPai[atual] ?? const <Categoria>[];

      for (final filho in filhos) {
        if (resultado.add(filho.id)) {
          pendentes.add(filho.id);
        }
      }
    }

    return resultado.toList(growable: false);
  }
}

class _ProdutoBusca {
  const _ProdutoBusca({
    required this.termos,
    required this.textoLiteral,
    required this.exigeTextoLiteral,
  });

  factory _ProdutoBusca.from(String value) {
    final textoLiteral = value.trim().toLowerCase();
    final termos = _normalizarTexto(value)
        .split(' ')
        .where((termo) => termo.isNotEmpty)
        .toList(growable: false);

    return _ProdutoBusca(
      termos: termos,
      textoLiteral: textoLiteral,
      exigeTextoLiteral: RegExp(r'[%_]').hasMatch(textoLiteral),
    );
  }

  final List<String> termos;
  final String textoLiteral;
  final bool exigeTextoLiteral;

  bool get isEmpty => termos.isEmpty && textoLiteral.isEmpty;

  static String _normalizarTexto(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[áàâãä]'), 'a')
        .replaceAll(RegExp(r'[éèêë]'), 'e')
        .replaceAll(RegExp(r'[íìîï]'), 'i')
        .replaceAll(RegExp(r'[óòôõö]'), 'o')
        .replaceAll(RegExp(r'[úùûü]'), 'u')
        .replaceAll('ç', 'c')
        .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
