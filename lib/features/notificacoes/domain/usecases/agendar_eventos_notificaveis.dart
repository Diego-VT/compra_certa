import '../../../../services/notificacoes/domain/repositories/notificacao_local_client.dart';
import '../entities/evento_notificavel_entity.dart';

class AgendarEventosNotificaveis {
  const AgendarEventosNotificaveis(this._client);

  final NotificacaoLocalClient _client;

  Future<void> call(List<EventoNotificavelEntity> eventos) async {
    final idsAgendados = <int>{};

    for (final evento in eventos) {
      if (!idsAgendados.add(evento.notificacaoId)) {
        continue;
      }

      await _client.agendar(evento.toRequest());
    }
  }
}
