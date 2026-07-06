import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../compras/application/compra_providers.dart';
import '../../estoque/application/estoque_providers.dart';
import '../../listas_compras/application/lista_compra_providers.dart';
import '../data/repositories/dashboard_repository_impl.dart';
import '../domain/usecases/obter_dashboard_resumo.dart';

final dashboardRepositoryProvider = Provider<DashboardRepositoryImpl>((ref) {
  return DashboardRepositoryImpl(
    estoqueRepository: ref.watch(estoqueRepositoryProvider),
    compraRepository: ref.watch(compraRepositoryProvider),
    listaCompraRepository: ref.watch(listaCompraRepositoryProvider),
  );
});

final obterDashboardResumoUseCaseProvider = Provider<ObterDashboardResumo>((
  ref,
) {
  return ObterDashboardResumo(ref.watch(dashboardRepositoryProvider));
});

final dashboardResumoProvider = FutureProvider((ref) {
  return ref.watch(obterDashboardResumoUseCaseProvider).call();
});
