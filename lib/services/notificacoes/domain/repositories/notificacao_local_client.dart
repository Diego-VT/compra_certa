import '../entities/notificacao_local_request.dart';

abstract class NotificacaoLocalClient {
  Future<void> agendar(NotificacaoLocalRequest request);

  Future<void> cancelar(int id);
}
