import '../../../../services/notificacoes/domain/repositories/notificacao_local_client.dart';
import '../entities/preferencias_notificacao_entity.dart';
import 'agendar_eventos_notificaveis.dart';
import 'detectar_eventos_notificaveis.dart';

class SincronizarEventosNotificaveis {
  const SincronizarEventosNotificaveis(
    this._detectar,
    this._agendar,
    this._client,
  );

  final DetectarEventosNotificaveis _detectar;
  final AgendarEventosNotificaveis _agendar;
  final NotificacaoLocalClient _client;

  Future<int> call(
    PreferenciasNotificacaoEntity preferencias, {
    bool solicitarPermissao = false,
  }) async {
    await _client.inicializar();
    if (solicitarPermissao && preferencias.notificacoesAtivas) {
      final permitido = await _client.solicitarPermissao();
      if (!permitido) {
        return 0;
      }
    }

    await _client.cancelarTodos();

    final ativos = await _detectar.call(preferencias);
    await _agendar.call(ativos);
    return ativos.length;
  }
}
