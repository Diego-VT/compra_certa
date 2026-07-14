import '../entities/relatorio_periodo_filtro.dart';
import '../entities/relatorio_resumo_entity.dart';

abstract class RelatorioRepository {
  Future<RelatorioResumoEntity> obterResumo(RelatorioPeriodoFiltro filtro);
}
