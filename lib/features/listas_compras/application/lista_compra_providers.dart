import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/dependency_providers.dart';
import '../data/datasources/lista_compra_local_data_source.dart';
import '../data/repositories/lista_compra_repository_impl.dart';
import '../domain/entities/lista_compra_entity.dart';
import '../domain/entities/lista_compra_filtro.dart';
import '../domain/entities/lista_compra_list_item_entity.dart';
import '../domain/repositories/lista_compra_repository.dart';
import '../domain/usecases/adicionar_item_lista_compra.dart';
import '../domain/usecases/concluir_lista_compra.dart';
import '../domain/usecases/criar_lista_compra.dart';
import '../domain/usecases/gerar_historico_compra_lista.dart';
import '../domain/usecases/gerar_lista_por_estoque_baixo.dart';
import '../domain/usecases/listar_listas_compras.dart';
import '../domain/usecases/marcar_item_lista_comprado.dart';
import '../domain/usecases/obter_lista_compra_por_id.dart';

final listaCompraLocalDataSourceProvider = Provider<ListaCompraLocalDataSource>(
  (ref) {
    return ListaCompraLocalDataSourceImpl(ref.watch(appDatabaseProvider));
  },
);

final listaCompraRepositoryProvider = Provider<ListaCompraRepository>((ref) {
  return ListaCompraRepositoryImpl(
    localDataSource: ref.watch(listaCompraLocalDataSourceProvider),
  );
});

final criarListaCompraUseCaseProvider = Provider<CriarListaCompra>((ref) {
  return CriarListaCompra(ref.watch(listaCompraRepositoryProvider));
});

final concluirListaCompraUseCaseProvider = Provider<ConcluirListaCompra>((
  ref,
) {
  return ConcluirListaCompra(ref.watch(listaCompraRepositoryProvider));
});

final gerarHistoricoCompraListaUseCaseProvider =
    Provider<GerarHistoricoCompraLista>((ref) {
      return GerarHistoricoCompraLista(
        ref.watch(listaCompraRepositoryProvider),
      );
    });

final listarListasComprasUseCaseProvider = Provider<ListarListasCompras>((ref) {
  return ListarListasCompras(ref.watch(listaCompraRepositoryProvider));
});

final obterListaCompraPorIdUseCaseProvider = Provider<ObterListaCompraPorId>((
  ref,
) {
  return ObterListaCompraPorId(ref.watch(listaCompraRepositoryProvider));
});

final adicionarItemListaCompraUseCaseProvider =
    Provider<AdicionarItemListaCompra>((ref) {
      return AdicionarItemListaCompra(ref.watch(listaCompraRepositoryProvider));
    });

final marcarItemListaCompradoUseCaseProvider =
    Provider<MarcarItemListaComprado>((ref) {
      return MarcarItemListaComprado(ref.watch(listaCompraRepositoryProvider));
    });

final gerarListaPorEstoqueBaixoUseCaseProvider =
    Provider<GerarListaPorEstoqueBaixo>((ref) {
      return GerarListaPorEstoqueBaixo(
        ref.watch(listaCompraRepositoryProvider),
      );
    });

final listaCompraFiltroProvider = StateProvider<ListaCompraFiltro>((ref) {
  return const ListaCompraFiltro();
});

final listasComprasProvider = FutureProvider<List<ListaCompraListItemEntity>>((
  ref,
) {
  final filtro = ref.watch(listaCompraFiltroProvider);

  return ref.watch(listarListasComprasUseCaseProvider).call(filtro);
});

final listaCompraPorIdProvider = FutureProvider.family<ListaCompraEntity?, int>(
  (ref, id) {
    return ref.watch(obterListaCompraPorIdUseCaseProvider).call(id);
  },
);
