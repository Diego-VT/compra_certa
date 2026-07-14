import '../entities/relatorio_periodo_filtro.dart';
import '../entities/relatorio_resumo_entity.dart';
import '../repositories/relatorio_repository.dart';

class ObterRelatorioResumo {
  const ObterRelatorioResumo(this._repository);

  final RelatorioRepository _repository;

  Future<RelatorioResumoEntity> call(RelatorioPeriodoFiltro filtro) {
    return _repository.obterResumo(filtro);
  }
}
