import 'package:drift/drift.dart';

import '../../../../database/app_database.dart';
import '../../domain/entities/lista_compra_entity.dart';
import '../../domain/entities/lista_compra_filtro.dart';
import '../../domain/entities/lista_compra_form_data.dart';
import '../../domain/entities/lista_compra_item_entity.dart';
import '../../domain/entities/lista_compra_list_item_entity.dart';
import '../../domain/entities/lista_compra_status.dart';

abstract class ListaCompraLocalDataSource {
  Future<int> criarLista(ListaCompraFormData data);

  Future<ListaCompraEntity?> obterListaPorId(int id);

  Future<List<ListaCompraListItemEntity>> listarListas(
    ListaCompraFiltro filtro,
  );

  Future<void> adicionarItem(ListaCompraItemFormData data);

  Future<void> editarItem(ListaCompraItemUpdateData data);

  Future<void> removerItem(int itemId);

  Future<void> concluirLista(int id);

  Future<void> gerarHistoricoCompra(int id);

  Future<void> marcarItemComprado({
    required int itemId,
    required bool isComprado,
    required double quantidadeComprada,
  });

  Future<int> gerarListaPorEstoqueBaixo(String nome);
}

class ListaCompraLocalDataSourceImpl implements ListaCompraLocalDataSource {
  const ListaCompraLocalDataSourceImpl(this._database);

  final AppDatabase _database;

  @override
  Future<int> criarLista(ListaCompraFormData data) {
    final nome = data.nome.trim();

    if (nome.isEmpty) {
      throw ArgumentError('Nome da lista e obrigatorio.');
    }

    return _database
        .into(_database.listasCompras)
        .insert(
          ListasComprasCompanion.insert(
            nome: nome,
            status: ListaCompraStatus.aberta.value,
          ),
        );
  }

  @override
  Future<ListaCompraEntity?> obterListaPorId(int id) async {
    final lista = await (_database.select(
      _database.listasCompras,
    )..where((table) => table.id.equals(id))).getSingleOrNull();

    if (lista == null) {
      return null;
    }

    final rows =
        await (_database.select(_database.itensListaCompras).join([
                innerJoin(
                  _database.produtos,
                  _database.produtos.id.equalsExp(
                    _database.itensListaCompras.produtoId,
                  ),
                ),
              ])
              ..where(_database.itensListaCompras.listaCompraId.equals(id))
              ..orderBy([OrderingTerm.asc(_database.produtos.nome)]))
            .get();

    final itens = rows
        .map((row) {
          final item = row.readTable(_database.itensListaCompras);
          final produto = row.readTable(_database.produtos);

          return ListaCompraItemEntity(
            id: item.id,
            listaCompraId: item.listaCompraId,
            produtoId: item.produtoId,
            produtoNome: produto.nome,
            unidadeMedida: produto.unidadeMedida,
            quantidadePlanejada: item.quantidadePlanejada,
            quantidadeComprada: item.quantidadeComprada,
            isComprado: item.isComprado,
            observacoes: item.observacoes,
            criadoEm: item.criadoEm,
            atualizadoEm: item.atualizadoEm,
          );
        })
        .toList(growable: false);

    return ListaCompraEntity(
      id: lista.id,
      nome: lista.nome,
      status: ListaCompraStatus.fromValue(lista.status),
      criadoEm: lista.criadoEm,
      atualizadoEm: lista.atualizadoEm,
      concluidoEm: lista.concluidoEm,
      itens: itens,
    );
  }

  @override
  Future<List<ListaCompraListItemEntity>> listarListas(
    ListaCompraFiltro filtro,
  ) async {
    if (filtro.limit <= 0) {
      throw ArgumentError('Limite deve ser maior que zero.');
    }

    if (filtro.offset < 0) {
      throw ArgumentError('Offset nao pode ser negativo.');
    }

    final query = _database.select(_database.listasCompras)
      ..orderBy([(table) => OrderingTerm.desc(table.id)])
      ..limit(filtro.limit, offset: filtro.offset);

    if (filtro.status != null) {
      query.where((table) => table.status.equals(filtro.status!.value));
    }

    final listas = await query.get();
    final listasIds = listas.map((lista) => lista.id).toList();

    if (listasIds.isEmpty) {
      return const [];
    }

    final itens = await (_database.select(
      _database.itensListaCompras,
    )..where((table) => table.listaCompraId.isIn(listasIds))).get();
    final itensPorLista = <int, List<ItensListaCompra>>{};

    for (final item in itens) {
      itensPorLista.putIfAbsent(item.listaCompraId, () => []).add(item);
    }

    return listas
        .map((lista) {
          final itensDaLista =
              itensPorLista[lista.id] ?? const <ItensListaCompra>[];

          return ListaCompraListItemEntity(
            id: lista.id,
            nome: lista.nome,
            status: ListaCompraStatus.fromValue(lista.status),
            totalItens: itensDaLista.length,
            totalComprados: itensDaLista
                .where((item) => item.isComprado)
                .length,
            criadoEm: lista.criadoEm,
            atualizadoEm: lista.atualizadoEm,
            concluidoEm: lista.concluidoEm,
          );
        })
        .toList(growable: false);
  }

  @override
  Future<void> adicionarItem(ListaCompraItemFormData data) {
    _validarItem(data);

    return _database.transaction(() async {
      final lista = await _obterListaAberta(data.listaCompraId);
      final produto = await _obterProdutoAtivo(data.produtoId);
      final itemExistente =
          await (_database.select(_database.itensListaCompras)..where(
                (table) =>
                    table.listaCompraId.equals(lista.id) &
                    table.produtoId.equals(produto.id),
              ))
              .getSingleOrNull();

      if (itemExistente != null) {
        throw StateError('Produto ja existe na lista.');
      }

      await _database
          .into(_database.itensListaCompras)
          .insert(
            ItensListaComprasCompanion.insert(
              listaCompraId: lista.id,
              produtoId: produto.id,
              quantidadePlanejada: data.quantidadePlanejada,
              observacoes: Value(_emptyToNull(data.observacoes)),
            ),
          );

      await _marcarListaAtualizada(lista.id);
    });
  }

  @override
  Future<void> editarItem(ListaCompraItemUpdateData data) {
    if (data.itemId <= 0) {
      throw ArgumentError('Item invalido.');
    }

    if (data.quantidadePlanejada <= 0) {
      throw ArgumentError('Quantidade planejada deve ser maior que zero.');
    }

    return _database.transaction(() async {
      final item = await (_database.select(
        _database.itensListaCompras,
      )..where((table) => table.id.equals(data.itemId))).getSingleOrNull();

      if (item == null) {
        throw StateError('Item nao encontrado.');
      }

      await _obterListaAberta(item.listaCompraId);

      await (_database.update(_database.itensListaCompras)
            ..where((table) => table.id.equals(data.itemId)))
          .write(
            ItensListaComprasCompanion(
              quantidadePlanejada: Value(data.quantidadePlanejada),
              observacoes: Value(_emptyToNull(data.observacoes)),
              atualizadoEm: Value(DateTime.now()),
            ),
          );

      await _marcarListaAtualizada(item.listaCompraId);
    });
  }

  @override
  Future<void> removerItem(int itemId) {
    if (itemId <= 0) {
      throw ArgumentError('Item invalido.');
    }

    return _database.transaction(() async {
      final item = await (_database.select(
        _database.itensListaCompras,
      )..where((table) => table.id.equals(itemId))).getSingleOrNull();

      if (item == null) {
        throw StateError('Item nao encontrado.');
      }

      await _obterListaAberta(item.listaCompraId);

      await (_database.delete(
        _database.itensListaCompras,
      )..where((table) => table.id.equals(itemId))).go();

      await _marcarListaAtualizada(item.listaCompraId);
    });
  }

  @override
  Future<void> concluirLista(int id) async {
    if (id <= 0) {
      throw ArgumentError('Lista invalida.');
    }

    await _database.transaction(() async {
      final lista = await (_database.select(
        _database.listasCompras,
      )..where((table) => table.id.equals(id))).getSingleOrNull();

      if (lista == null) {
        throw StateError('Lista nao encontrada.');
      }

      if (ListaCompraStatus.fromValue(lista.status) != ListaCompraStatus.aberta) {
        throw StateError('Lista ja concluida.');
      }

      await (_database.update(_database.listasCompras)
            ..where((table) => table.id.equals(id)))
          .write(
            ListasComprasCompanion(
              status: Value(ListaCompraStatus.concluida.value),
              concluidoEm: Value(DateTime.now()),
              atualizadoEm: Value(DateTime.now()),
            ),
          );
    });
  }

  @override
  Future<void> gerarHistoricoCompra(int id) async {
    if (id <= 0) {
      throw ArgumentError('Lista invalida.');
    }

    await _database.transaction(() async {
      final lista = await (_database.select(
        _database.listasCompras,
      )..where((table) => table.id.equals(id))).getSingleOrNull();

      if (lista == null) {
        throw StateError('Lista nao encontrada.');
      }

      final itens = await (_database.select(
        _database.itensListaCompras,
      )..where((table) => table.listaCompraId.equals(id))).get();

      if (itens.isEmpty) {
        throw StateError('Lista sem itens para gerar historico.');
      }

      final compraId = await _database.into(_database.compras).insert(
        ComprasCompanion.insert(
          dataCompra: DateTime.now(),
          observacoes: Value('Gerado a partir da lista ${lista.nome}'),
        ),
      );

      for (final item in itens) {
        await _database.into(_database.itensCompra).insert(
          ItensCompraCompanion.insert(
            compraId: compraId,
            produtoId: item.produtoId,
            quantidade: item.quantidadeComprada > 0
                ? item.quantidadeComprada
                : item.quantidadePlanejada,
          ),
        );
      }
    });
  }

  @override
  Future<void> marcarItemComprado({
    required int itemId,
    required bool isComprado,
    required double quantidadeComprada,
  }) {
    if (itemId <= 0) {
      throw ArgumentError('Item invalido.');
    }

    if (quantidadeComprada < 0) {
      throw ArgumentError('Quantidade comprada nao pode ser negativa.');
    }

    return _database.transaction(() async {
      final item = await (_database.select(
        _database.itensListaCompras,
      )..where((table) => table.id.equals(itemId))).getSingleOrNull();

      if (item == null) {
        throw StateError('Item nao encontrado.');
      }

      await _obterListaAberta(item.listaCompraId);

      await (_database.update(
        _database.itensListaCompras,
      )..where((table) => table.id.equals(itemId))).write(
        ItensListaComprasCompanion(
          isComprado: Value(isComprado),
          quantidadeComprada: Value(isComprado ? quantidadeComprada : 0),
          atualizadoEm: Value(DateTime.now()),
        ),
      );

      await _marcarListaAtualizada(item.listaCompraId);
    });
  }

  @override
  Future<int> gerarListaPorEstoqueBaixo(String nome) {
    final nomeNormalizado = nome.trim();

    if (nomeNormalizado.isEmpty) {
      throw ArgumentError('Nome da lista e obrigatorio.');
    }

    return _database.transaction(() async {
      final rows =
          await (_database.select(_database.produtos).join([
                  leftOuterJoin(
                    _database.estoques,
                    _database.estoques.produtoId.equalsExp(
                      _database.produtos.id,
                    ),
                  ),
                ])
                ..where(_database.produtos.isAtivo.equals(true))
                ..where(
                  const CustomExpression<bool>(
                    'COALESCE(estoques.quantidade_atual, 0) < produtos.quantidade_minima',
                  ),
                )
                ..orderBy([OrderingTerm.asc(_database.produtos.nome)]))
              .get();

      if (rows.isEmpty) {
        throw StateError('Nenhum produto abaixo do minimo.');
      }

      final listaId = await criarLista(
        ListaCompraFormData(nome: nomeNormalizado),
      );

      for (final row in rows) {
        final produto = row.readTable(_database.produtos);
        final estoque = row.readTableOrNull(_database.estoques);
        final quantidadeAtual = estoque?.quantidadeAtual ?? 0;
        final alvo = produto.quantidadeIdeal > quantidadeAtual
            ? produto.quantidadeIdeal
            : produto.quantidadeMinima;
        final quantidadePlanejada = alvo - quantidadeAtual;

        if (quantidadePlanejada <= 0) {
          continue;
        }

        await _database
            .into(_database.itensListaCompras)
            .insert(
              ItensListaComprasCompanion.insert(
                listaCompraId: listaId,
                produtoId: produto.id,
                quantidadePlanejada: quantidadePlanejada,
                observacoes: const Value('Gerado por estoque baixo'),
              ),
            );
      }

      return listaId;
    });
  }

  void _validarItem(ListaCompraItemFormData data) {
    if (data.listaCompraId <= 0) {
      throw ArgumentError('Lista invalida.');
    }

    if (data.produtoId <= 0) {
      throw ArgumentError('Produto invalido.');
    }

    if (data.quantidadePlanejada <= 0) {
      throw ArgumentError('Quantidade planejada deve ser maior que zero.');
    }
  }

  Future<ListasCompra> _obterListaAberta(int id) async {
    final lista = await (_database.select(
      _database.listasCompras,
    )..where((table) => table.id.equals(id))).getSingleOrNull();

    if (lista == null) {
      throw StateError('Lista nao encontrada.');
    }

    if (ListaCompraStatus.fromValue(lista.status) != ListaCompraStatus.aberta) {
      throw StateError('Lista concluida nao pode ser alterada.');
    }

    return lista;
  }

  Future<Produto> _obterProdutoAtivo(int id) async {
    final produto = await (_database.select(
      _database.produtos,
    )..where((table) => table.id.equals(id))).getSingleOrNull();

    if (produto == null) {
      throw StateError('Produto nao encontrado.');
    }

    if (!produto.isAtivo) {
      throw StateError('Produto inativo nao pode ser adicionado a lista.');
    }

    return produto;
  }

  Future<void> _marcarListaAtualizada(int id) {
    return (_database.update(_database.listasCompras)
          ..where((table) => table.id.equals(id)))
        .write(ListasComprasCompanion(atualizadoEm: Value(DateTime.now())));
  }

  String? _emptyToNull(String? value) {
    final normalized = value?.trim();

    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    return normalized;
  }
}
