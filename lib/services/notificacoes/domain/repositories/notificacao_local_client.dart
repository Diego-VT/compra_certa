import '../entities/notificacao_local_request.dart';

abstract class NotificacaoLocalClient {
  Future<void> inicializar();

  Future<bool> solicitarPermissao();

  Future<void> agendar(NotificacaoLocalRequest request);

  Future<void> cancelar(int id);
}
