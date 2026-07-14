import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/dependency_providers.dart';
import '../data/datasources/relatorio_local_data_source.dart';
import '../data/repositories/relatorio_repository_impl.dart';
import '../domain/entities/relatorio_periodo_filtro.dart';
import '../domain/entities/relatorio_resumo_entity.dart';
import '../domain/repositories/relatorio_repository.dart';
import '../domain/usecases/obter_relatorio_resumo.dart';

final relatorioLocalDataSourceProvider = Provider<RelatorioLocalDataSource>((
  ref,
) {
  return RelatorioLocalDataSourceImpl(ref.watch(appDatabaseProvider));
});

final relatorioRepositoryProvider = Provider<RelatorioRepository>((ref) {
  return RelatorioRepositoryImpl(
    localDataSource: ref.watch(relatorioLocalDataSourceProvider),
  );
});

final obterRelatorioResumoUseCaseProvider = Provider<ObterRelatorioResumo>((
  ref,
) {
  return ObterRelatorioResumo(ref.watch(relatorioRepositoryProvider));
});

final relatorioFiltroProvider = StateProvider<RelatorioPeriodoFiltro>((ref) {
  final hoje = DateTime.now();
  return RelatorioPeriodoFiltro(
    inicio: DateTime(hoje.year, hoje.month, hoje.day).subtract(
      const Duration(days: 29),
    ),
    fim: hoje,
  );
});

final relatorioResumoProvider = FutureProvider<RelatorioResumoEntity>((ref) {
  final filtro = ref.watch(relatorioFiltroProvider);

  return ref.watch(obterRelatorioResumoUseCaseProvider).call(filtro);
});
