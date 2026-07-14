import '../../domain/entities/relatorio_periodo_filtro.dart';
import '../../domain/entities/relatorio_resumo_entity.dart';
import '../../domain/repositories/relatorio_repository.dart';
import '../datasources/relatorio_local_data_source.dart';

class RelatorioRepositoryImpl implements RelatorioRepository {
  const RelatorioRepositoryImpl({required this.localDataSource});

  final RelatorioLocalDataSource localDataSource;

  @override
  Future<RelatorioResumoEntity> obterResumo(RelatorioPeriodoFiltro filtro) {
    return localDataSource.obterResumo(filtro);
  }
}
