import '../../../../services/notificacoes/domain/entities/notificacao_local_request.dart';
import 'notificacao_evento_tipo.dart';

class EventoNotificavelEntity {
  const EventoNotificavelEntity({
    required this.tipo,
    required this.referenciaId,
    required this.titulo,
    required this.mensagem,
  });

  final NotificacaoEventoTipo tipo;
  final int referenciaId;
  final String titulo;
  final String mensagem;

  String get chave {
    return switch (tipo) {
      NotificacaoEventoTipo.estoqueBaixo => 'estoque_baixo:$referenciaId',
      NotificacaoEventoTipo.listaPendente => 'lista_pendente:$referenciaId',
    };
  }

  int get notificacaoId {
    return switch (tipo) {
      NotificacaoEventoTipo.estoqueBaixo => 100000 + referenciaId,
      NotificacaoEventoTipo.listaPendente => 200000 + referenciaId,
    };
  }

  NotificacaoLocalRequest toRequest() {
    return NotificacaoLocalRequest(
      id: notificacaoId,
      chave: chave,
      titulo: titulo,
      mensagem: mensagem,
    );
  }
}
