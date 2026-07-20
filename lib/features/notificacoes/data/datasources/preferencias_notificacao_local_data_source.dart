import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/preferencias_notificacao_entity.dart';

class PreferenciasNotificacaoLocalDataSource {
  const PreferenciasNotificacaoLocalDataSource();

  static const _notificacoesAtivasKey = 'notificacoes_ativas';
  static const _alertarEstoqueBaixoKey = 'alertar_estoque_baixo';
  static const _alertarListasPendentesKey = 'alertar_listas_pendentes';

  Future<PreferenciasNotificacaoEntity> obter() async {
    final preferences = await SharedPreferences.getInstance();
    return PreferenciasNotificacaoEntity(
      notificacoesAtivas: preferences.getBool(_notificacoesAtivasKey) ?? true,
      alertarEstoqueBaixo:
          preferences.getBool(_alertarEstoqueBaixoKey) ?? true,
      alertarListasPendentes:
          preferences.getBool(_alertarListasPendentesKey) ?? true,
    );
  }

  Future<void> salvar(PreferenciasNotificacaoEntity preferencias) async {
    final storage = await SharedPreferences.getInstance();
    await Future.wait([
      storage.setBool(
        _notificacoesAtivasKey,
        preferencias.notificacoesAtivas,
      ),
      storage.setBool(
        _alertarEstoqueBaixoKey,
        preferencias.alertarEstoqueBaixo,
      ),
      storage.setBool(
        _alertarListasPendentesKey,
        preferencias.alertarListasPendentes,
      ),
    ]);
  }
}
