import '../entities/dashboard_resumo_entity.dart';

abstract class DashboardRepository {
  Future<DashboardResumoEntity> obterResumo();
}
