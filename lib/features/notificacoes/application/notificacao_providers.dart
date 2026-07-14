import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/notificacoes/data/clients/notificacao_disabled_client.dart';
import '../../../services/notificacoes/domain/repositories/notificacao_local_client.dart';
import '../../estoque/application/estoque_providers.dart';
import '../../listas_compras/application/lista_compra_providers.dart';
import '../domain/entities/evento_notificavel_entity.dart';
import '../domain/entities/preferencias_notificacao_entity.dart';
import '../domain/usecases/agendar_eventos_notificaveis.dart';
import '../domain/usecases/cancelar_eventos_notificaveis.dart';
import '../domain/usecases/detectar_eventos_notificaveis.dart';

final notificacaoLocalClientProvider = Provider<NotificacaoLocalClient>((ref) {
  return const NotificacaoDisabledClient();
});

final preferenciasNotificacaoProvider =
    StateProvider<PreferenciasNotificacaoEntity>((ref) {
      return const PreferenciasNotificacaoEntity();
    });

final detectarEventosNotificaveisUseCaseProvider =
    Provider<DetectarEventosNotificaveis>((ref) {
      return DetectarEventosNotificaveis(
        listarProdutosAbaixoMinimo: ref.watch(
          listarProdutosAbaixoMinimoUseCaseProvider,
        ),
        listarListasCompras: ref.watch(listarListasComprasUseCaseProvider),
      );
    });

final agendarEventosNotificaveisUseCaseProvider =
    Provider<AgendarEventosNotificaveis>((ref) {
      return AgendarEventosNotificaveis(
        ref.watch(notificacaoLocalClientProvider),
      );
    });

final cancelarEventosNotificaveisUseCaseProvider =
    Provider<CancelarEventosNotificaveis>((ref) {
      return CancelarEventosNotificaveis(
        ref.watch(notificacaoLocalClientProvider),
      );
    });

final eventosNotificaveisProvider =
    FutureProvider<List<EventoNotificavelEntity>>((ref) {
      final preferencias = ref.watch(preferenciasNotificacaoProvider);

      return ref.watch(detectarEventosNotificaveisUseCaseProvider).call(
            preferencias,
          );
    });
