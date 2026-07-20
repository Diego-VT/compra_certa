import '../../domain/entities/notificacao_local_request.dart';
import '../../domain/repositories/notificacao_local_client.dart';

class NotificacaoDisabledClient implements NotificacaoLocalClient {
  const NotificacaoDisabledClient();

  @override
  Future<void> inicializar() async {}

  @override
  Future<bool> solicitarPermissao() async => false;

  @override
  Future<void> agendar(NotificacaoLocalRequest request) async {}

  @override
  Future<void> cancelar(int id) async {}

  @override
  Future<void> cancelarTodos() async {}
}
