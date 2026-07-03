import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/dependency_providers.dart';
import '../data/datasources/compra_local_data_source.dart';
import '../data/repositories/compra_repository_impl.dart';
import '../domain/entities/compra_entity.dart';
import '../domain/entities/compra_filtro.dart';
import '../domain/entities/compra_list_item_entity.dart';
import '../domain/repositories/compra_repository.dart';
import '../domain/usecases/listar_compras_por_periodo.dart';
import '../domain/usecases/obter_compra_por_id.dart';
import '../domain/usecases/registrar_compra.dart';

final compraLocalDataSourceProvider = Provider<CompraLocalDataSource>((ref) {
  return CompraLocalDataSourceImpl(ref.watch(appDatabaseProvider));
});

final compraRepositoryProvider = Provider<CompraRepository>((ref) {
  return CompraRepositoryImpl(
    localDataSource: ref.watch(compraLocalDataSourceProvider),
  );
});

final registrarCompraUseCaseProvider = Provider<RegistrarCompra>((ref) {
  return RegistrarCompra(ref.watch(compraRepositoryProvider));
});

final listarComprasPorPeriodoUseCaseProvider =
    Provider<ListarComprasPorPeriodo>((ref) {
      return ListarComprasPorPeriodo(ref.watch(compraRepositoryProvider));
    });

final obterCompraPorIdUseCaseProvider = Provider<ObterCompraPorId>((ref) {
  return ObterCompraPorId(ref.watch(compraRepositoryProvider));
});

final compraFiltroProvider = StateProvider<CompraFiltro>((ref) {
  return const CompraFiltro();
});

final comprasProvider = FutureProvider<List<CompraListItemEntity>>((ref) {
  final filtro = ref.watch(compraFiltroProvider);

  return ref.watch(listarComprasPorPeriodoUseCaseProvider).call(filtro);
});

final compraPorIdProvider = FutureProvider.family<CompraEntity?, int>((
  ref,
  id,
) {
  return ref.watch(obterCompraPorIdUseCaseProvider).call(id);
});
