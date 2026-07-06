import '../entities/dashboard_resumo_entity.dart';
import '../repositories/dashboard_repository.dart';

class ObterDashboardResumo {
  const ObterDashboardResumo(this._repository);

  final DashboardRepository _repository;

  Future<DashboardResumoEntity> call() {
    return _repository.obterResumo();
  }
}
