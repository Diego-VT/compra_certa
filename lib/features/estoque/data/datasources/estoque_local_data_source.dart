import 'package:drift/drift.dart';

import '../../../../database/app_database.dart';
import '../../domain/entities/estoque_entity.dart';
import '../../domain/entities/movimentacao_estoque_tipo.dart';
import '../../domain/entities/registrar_movimentacao_estoque_data.dart';

abstract class EstoqueLocalDataSource {
  Future<List<EstoqueEntity>> listarResumoEstoque();

  Future<EstoqueEntity?> obterEstoquePorProduto(int produtoId);

  Future<EstoqueEntity> registrarMovimentacao(
    RegistrarMovimentacaoEstoqueData movimentacao,
  );

  Future<List<EstoqueEntity>> listarProdutosAbaixoMinimo();
}

class EstoqueLocalDataSourceImpl implements EstoqueLocalDataSource {
  const EstoqueLocalDataSourceImpl(this._database);

  final AppDatabase _database;

  @override
  Future<List<EstoqueEntity>> listarResumoEstoque() async {
    final produtos = await (_database.select(
      _database.produtos,
    )..orderBy([(table) => OrderingTerm.asc(table.nome)])).get();
    final estoques = await _database.select(_database.estoques).get();
    final estoquesPorProduto = {
      for (final estoque in estoques) estoque.produtoId: estoque,
    };

    return produtos
        .map((produto) => _mapEstoque(produto, estoquesPorProduto[produto.id]))
        .toList(growable: false);
  }

  @override
  Future<EstoqueEntity?> obterEstoquePorProduto(int produtoId) async {
    final produto = await (_database.select(
      _database.produtos,
    )..where((table) => table.id.equals(produtoId))).getSingleOrNull();

    if (produto == null) {
      return null;
    }

    final estoque = await (_database.select(
      _database.estoques,
    )..where((table) => table.produtoId.equals(produtoId))).getSingleOrNull();

    return _mapEstoque(produto, estoque);
  }

  @override
  Future<EstoqueEntity> registrarMovimentacao(
    RegistrarMovimentacaoEstoqueData movimentacao,
  ) {
    if (movimentacao.quantidade < 0) {
      throw ArgumentError('Quantidade nao pode ser negativa.');
    }

    return _database.transaction(() async {
      final produto =
          await (_database.select(_database.produtos)
                ..where((table) => table.id.equals(movimentacao.produtoId)))
              .getSingleOrNull();

      if (produto == null) {
        throw StateError('Produto nao encontrado.');
      }

      if (!produto.isAtivo) {
        throw StateError('Produto inativo nao pode receber movimentacao.');
      }

      final estoqueAtual =
          await (_database.select(_database.estoques)..where(
                (table) => table.produtoId.equals(movimentacao.produtoId),
              ))
              .getSingleOrNull();

      final quantidadeAnterior = estoqueAtual?.quantidadeAtual ?? 0;
      final quantidadeFinal = _calcularQuantidadeFinal(
        quantidadeAnterior: quantidadeAnterior,
        movimentacao: movimentacao,
      );

      if (quantidadeFinal < 0) {
        throw StateError('Estoque nao pode ficar negativo.');
      }

      final agora = DateTime.now();

      if (estoqueAtual == null) {
        await _database
            .into(_database.estoques)
            .insert(
              EstoquesCompanion.insert(
                produtoId: movimentacao.produtoId,
                quantidadeAtual: Value(quantidadeFinal),
                atualizadoEm: Value(agora),
              ),
            );
      } else {
        await (_database.update(
              _database.estoques,
            )..where((table) => table.produtoId.equals(movimentacao.produtoId)))
            .write(
              EstoquesCompanion(
                quantidadeAtual: Value(quantidadeFinal),
                atualizadoEm: Value(agora),
              ),
            );
      }

      await _database
          .into(_database.movimentacoesEstoque)
          .insert(
            MovimentacoesEstoqueCompanion.insert(
              produtoId: movimentacao.produtoId,
              tipo: movimentacao.tipo.value,
              quantidade: movimentacao.quantidade,
              quantidadeAnterior: quantidadeAnterior,
              quantidadeFinal: quantidadeFinal,
              motivo: Value(_emptyToNull(movimentacao.motivo)),
              criadoEm: Value(agora),
            ),
          );

      final estoqueSalvo =
          await (_database.select(_database.estoques)..where(
                (table) => table.produtoId.equals(movimentacao.produtoId),
              ))
              .getSingle();

      return _mapEstoque(produto, estoqueSalvo);
    });
  }

  @override
  Future<List<EstoqueEntity>> listarProdutosAbaixoMinimo() async {
    final query =
        _database.select(_database.produtos).join([
            leftOuterJoin(
              _database.estoques,
              _database.estoques.produtoId.equalsExp(_database.produtos.id),
            ),
          ])
          ..where(_database.produtos.isAtivo.equals(true))
          ..where(
            const CustomExpression<bool>(
              'COALESCE(estoques.quantidade_atual, 0) < produtos.quantidade_minima',
            ),
          )
          ..orderBy([OrderingTerm.asc(_database.produtos.nome)]);

    final rows = await query.get();

    return rows
        .map(
          (row) => _mapEstoque(
            row.readTable(_database.produtos),
            row.readTableOrNull(_database.estoques),
          ),
        )
        .toList(growable: false);
  }

  double _calcularQuantidadeFinal({
    required double quantidadeAnterior,
    required RegistrarMovimentacaoEstoqueData movimentacao,
  }) {
    return switch (movimentacao.tipo) {
      MovimentacaoEstoqueTipo.entrada =>
        quantidadeAnterior + movimentacao.quantidade,
      MovimentacaoEstoqueTipo.saida =>
        quantidadeAnterior - movimentacao.quantidade,
      MovimentacaoEstoqueTipo.ajuste => movimentacao.quantidade,
    };
  }

  EstoqueEntity _mapEstoque(Produto produto, Estoque? estoque) {
    return EstoqueEntity(
      id: estoque?.id,
      produtoId: produto.id,
      produtoNome: produto.nome,
      unidadeMedida: produto.unidadeMedida,
      quantidadeAtual: estoque?.quantidadeAtual ?? 0,
      quantidadeMinima: produto.quantidadeMinima,
      quantidadeIdeal: produto.quantidadeIdeal,
      isProdutoAtivo: produto.isAtivo,
      atualizadoEm: estoque?.atualizadoEm,
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
