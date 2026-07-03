import 'package:drift/drift.dart';

import '../../../../database/app_database.dart';
import '../../domain/entities/compra_entity.dart';
import '../../domain/entities/compra_filtro.dart';
import '../../domain/entities/compra_item_entity.dart';
import '../../domain/entities/compra_list_item_entity.dart';
import '../../domain/entities/registrar_compra_data.dart';

abstract class CompraLocalDataSource {
  Future<CompraEntity> registrarCompra(RegistrarCompraData compra);

  Future<List<CompraListItemEntity>> listarComprasPorPeriodo(
    CompraFiltro filtro,
  );

  Future<CompraEntity?> obterCompraPorId(int id);
}

class CompraLocalDataSourceImpl implements CompraLocalDataSource {
  const CompraLocalDataSourceImpl(this._database);

  final AppDatabase _database;

  @override
  Future<CompraEntity> registrarCompra(RegistrarCompraData compra) {
    _validarCompra(compra);

    return _database.transaction(() async {
      final produtosIds = compra.itens
          .map((item) => item.produtoId)
          .toSet()
          .toList(growable: false);
      final produtos = await (_database.select(
        _database.produtos,
      )..where((table) => table.id.isIn(produtosIds))).get();

      if (produtos.length != produtosIds.length) {
        throw StateError('Compra possui produto inexistente.');
      }

      if (produtos.any((produto) => !produto.isAtivo)) {
        throw StateError('Compra possui produto inativo.');
      }

      final compraId = await _database
          .into(_database.compras)
          .insert(
            ComprasCompanion.insert(
              dataCompra: compra.dataCompra,
              observacoes: Value(_emptyToNull(compra.observacoes)),
            ),
          );

      for (final item in compra.itens) {
        await _database
            .into(_database.itensCompra)
            .insert(
              ItensCompraCompanion.insert(
                compraId: compraId,
                produtoId: item.produtoId,
                quantidade: item.quantidade,
                valorUnitario: Value(item.valorUnitario),
              ),
            );
      }

      final compraSalva = await obterCompraPorId(compraId);

      return compraSalva!;
    });
  }

  @override
  Future<List<CompraListItemEntity>> listarComprasPorPeriodo(
    CompraFiltro filtro,
  ) async {
    if (filtro.limit <= 0) {
      throw ArgumentError('Limite deve ser maior que zero.');
    }

    if (filtro.offset < 0) {
      throw ArgumentError('Offset nao pode ser negativo.');
    }

    final query = _database.select(_database.compras)
      ..orderBy([
        (table) => OrderingTerm.desc(table.dataCompra),
        (table) => OrderingTerm.desc(table.id),
      ])
      ..limit(filtro.limit, offset: filtro.offset);

    if (filtro.inicio != null) {
      query.where(
        (table) => table.dataCompra.isBiggerOrEqualValue(filtro.inicio!),
      );
    }

    if (filtro.fim != null) {
      final fimExclusivo = _inicioDoProximoDia(filtro.fim!);

      query.where((table) => table.dataCompra.isSmallerThanValue(fimExclusivo));
    }

    final compras = await query.get();
    final comprasIds = compras.map((compra) => compra.id).toList();

    if (comprasIds.isEmpty) {
      return const [];
    }

    final itens = await (_database.select(
      _database.itensCompra,
    )..where((table) => table.compraId.isIn(comprasIds))).get();
    final itensPorCompra = <int, List<ItensCompraData>>{};

    for (final item in itens) {
      itensPorCompra.putIfAbsent(item.compraId, () => []).add(item);
    }

    return compras
        .map((compra) {
          final itensDaCompra =
              itensPorCompra[compra.id] ?? const <ItensCompraData>[];
          return CompraListItemEntity(
            id: compra.id,
            dataCompra: compra.dataCompra,
            totalItens: itensDaCompra.length,
            valorTotal: _calcularValorTotal(itensDaCompra),
            observacoes: compra.observacoes,
            criadoEm: compra.criadoEm,
          );
        })
        .toList(growable: false);
  }

  @override
  Future<CompraEntity?> obterCompraPorId(int id) async {
    final compra = await (_database.select(
      _database.compras,
    )..where((table) => table.id.equals(id))).getSingleOrNull();

    if (compra == null) {
      return null;
    }

    final rows =
        await (_database.select(_database.itensCompra).join([
                innerJoin(
                  _database.produtos,
                  _database.produtos.id.equalsExp(
                    _database.itensCompra.produtoId,
                  ),
                ),
              ])
              ..where(_database.itensCompra.compraId.equals(id))
              ..orderBy([OrderingTerm.asc(_database.produtos.nome)]))
            .get();

    final itens = rows
        .map((row) {
          final item = row.readTable(_database.itensCompra);
          final produto = row.readTable(_database.produtos);

          return CompraItemEntity(
            id: item.id,
            compraId: item.compraId,
            produtoId: item.produtoId,
            produtoNome: produto.nome,
            unidadeMedida: produto.unidadeMedida,
            quantidade: item.quantidade,
            valorUnitario: item.valorUnitario,
          );
        })
        .toList(growable: false);

    return CompraEntity(
      id: compra.id,
      dataCompra: compra.dataCompra,
      criadoEm: compra.criadoEm,
      observacoes: compra.observacoes,
      itens: itens,
    );
  }

  void _validarCompra(RegistrarCompraData compra) {
    if (compra.itens.isEmpty) {
      throw ArgumentError('Compra deve ter ao menos um item.');
    }

    for (final item in compra.itens) {
      if (item.produtoId <= 0) {
        throw ArgumentError('Produto invalido.');
      }

      if (item.quantidade <= 0) {
        throw ArgumentError('Quantidade deve ser maior que zero.');
      }

      final valorUnitario = item.valorUnitario;

      if (valorUnitario != null && valorUnitario < 0) {
        throw ArgumentError('Valor unitario nao pode ser negativo.');
      }
    }
  }

  double? _calcularValorTotal(List<ItensCompraData> itens) {
    var total = 0.0;

    for (final item in itens) {
      final valorUnitario = item.valorUnitario;

      if (valorUnitario == null) {
        return null;
      }

      total += valorUnitario * item.quantidade;
    }

    return total;
  }

  String? _emptyToNull(String? value) {
    final normalized = value?.trim();

    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    return normalized;
  }

  DateTime _inicioDoProximoDia(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    ).add(const Duration(days: 1));
  }
}
