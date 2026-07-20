import '../entities/preferencias_notificacao_entity.dart';

abstract class PreferenciasNotificacaoRepository {
  Future<PreferenciasNotificacaoEntity> obter();

  Future<void> salvar(PreferenciasNotificacaoEntity preferencias);
}
