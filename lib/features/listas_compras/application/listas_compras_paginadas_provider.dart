import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/lista_compra_filtro.dart';
import '../domain/entities/lista_compra_list_item_entity.dart';
import '../domain/usecases/listar_listas_compras.dart';
import 'lista_compra_providers.dart';

class ListasComprasPaginadasNotifier
    extends StateNotifier<AsyncValue<List<ListaCompraListItemEntity>>> {
  ListasComprasPaginadasNotifier(this._useCase, this._ref)
      : super(const AsyncValue.loading()) {
    carregarMais();
  }

  final ListarListasCompras _useCase;
  final Ref _ref;

  final List<ListaCompraListItemEntity> _itens = <ListaCompraListItemEntity>[];
  bool _carregando = false;
  bool _temMais = true;
  int _offset = 0;

  Future<void> carregarMais() async {
    if (_carregando || !_temMais) {
      return;
    }

    _carregando = true;
    final filtro = _ref.read(listaCompraFiltroProvider);
    final nextOffset = _offset;

    state = AsyncValue<List<ListaCompraListItemEntity>>.loading().copyWithPrevious(state);

    try {
      final pagina = await _useCase.call(
        filtro.copyWith(limit: filtro.limit, offset: nextOffset),
      );

      if (pagina.isEmpty) {
        _temMais = false;
      } else {
        _itens.addAll(pagina);
        _offset += pagina.length;
        _temMais = pagina.length == filtro.limit;
      }

      state = AsyncValue.data(List<ListaCompraListItemEntity>.from(_itens));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    } finally {
      _carregando = false;
    }
  }

  void resetar() {
    _itens.clear();
    _offset = 0;
    _temMais = true;
    state = const AsyncValue.loading();
    carregarMais();
  }

  void aplicarFiltro(ListaCompraFiltro filtro) {
    if (filtro.status != _ref.read(listaCompraFiltroProvider).status) {
      _itens.clear();
      _offset = 0;
      _temMais = true;
      state = const AsyncValue.loading();
      carregarMais();
    }
  }
}

final listasComprasPaginadasProvider = StateNotifierProvider<
  ListasComprasPaginadasNotifier,
  AsyncValue<List<ListaCompraListItemEntity>>
>((ref) {
  return ListasComprasPaginadasNotifier(
    ref.watch(listarListasComprasUseCaseProvider),
    ref,
  );
});
