import 'package:compra_certa/features/notificacoes/domain/entities/evento_notificavel_entity.dart';
import 'package:compra_certa/features/notificacoes/domain/entities/notificacao_evento_tipo.dart';
import 'package:compra_certa/features/notificacoes/domain/usecases/agendar_eventos_notificaveis.dart';
import 'package:compra_certa/features/notificacoes/domain/usecases/cancelar_eventos_notificaveis.dart';
import 'package:compra_certa/services/notificacoes/domain/entities/notificacao_local_request.dart';
import 'package:compra_certa/services/notificacoes/domain/repositories/notificacao_local_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('agenda eventos sem duplicar o mesmo id de notificacao', () async {
    final client = _CapturingNotificacaoClient();
    final useCase = AgendarEventosNotificaveis(client);
    final evento = _evento();

    await useCase.call([evento, evento]);

    expect(client.agendadas, hasLength(1));
    expect(client.agendadas.single.id, 100001);
    expect(client.agendadas.single.chave, 'estoque_baixo:1');
  });

  test('cancela eventos sem repetir o mesmo id', () async {
    final client = _CapturingNotificacaoClient();
    final useCase = CancelarEventosNotificaveis(client);
    final evento = _evento();

    await useCase.call([evento, evento]);

    expect(client.canceladas, [100001]);
  });
}

EventoNotificavelEntity _evento() {
  return const EventoNotificavelEntity(
    tipo: NotificacaoEventoTipo.estoqueBaixo,
    referenciaId: 1,
    titulo: 'Reposicao necessaria',
    mensagem: 'Cafe esta abaixo do minimo.',
  );
}

class _CapturingNotificacaoClient implements NotificacaoLocalClient {
  final agendadas = <NotificacaoLocalRequest>[];
  final canceladas = <int>[];

  @override
  Future<void> inicializar() async {}

  @override
  Future<bool> solicitarPermissao() async => true;

  @override
  Future<void> agendar(NotificacaoLocalRequest request) async {
    agendadas.add(request);
  }

  @override
  Future<void> cancelar(int id) async {
    canceladas.add(id);
  }
}
