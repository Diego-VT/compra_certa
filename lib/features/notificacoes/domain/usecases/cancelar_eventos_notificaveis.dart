import '../../../../services/notificacoes/domain/repositories/notificacao_local_client.dart';
import '../entities/evento_notificavel_entity.dart';

class CancelarEventosNotificaveis {
  const CancelarEventosNotificaveis(this._client);

  final NotificacaoLocalClient _client;

  Future<void> call(List<EventoNotificavelEntity> eventos) async {
    final idsCancelados = <int>{};

    for (final evento in eventos) {
      if (!idsCancelados.add(evento.notificacaoId)) {
        continue;
      }

      await _client.cancelar(evento.notificacaoId);
    }
  }
}
