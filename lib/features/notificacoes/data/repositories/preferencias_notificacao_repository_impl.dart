import '../../domain/entities/preferencias_notificacao_entity.dart';
import '../../domain/repositories/preferencias_notificacao_repository.dart';
import '../datasources/preferencias_notificacao_local_data_source.dart';

class PreferenciasNotificacaoRepositoryImpl
    implements PreferenciasNotificacaoRepository {
  const PreferenciasNotificacaoRepositoryImpl(this._dataSource);

  final PreferenciasNotificacaoLocalDataSource _dataSource;

  @override
  Future<PreferenciasNotificacaoEntity> obter() => _dataSource.obter();

  @override
  Future<void> salvar(PreferenciasNotificacaoEntity preferencias) =>
      _dataSource.salvar(preferencias);
}
