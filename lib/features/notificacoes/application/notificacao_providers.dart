import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/notificacoes/data/clients/flutter_local_notificacao_client.dart';
import '../../../services/notificacoes/domain/repositories/notificacao_local_client.dart';
import '../../estoque/application/estoque_providers.dart';
import '../../listas_compras/application/lista_compra_providers.dart';
import '../data/datasources/preferencias_notificacao_local_data_source.dart';
import '../data/repositories/preferencias_notificacao_repository_impl.dart';
import '../domain/entities/evento_notificavel_entity.dart';
import '../domain/entities/preferencias_notificacao_entity.dart';
import '../domain/repositories/preferencias_notificacao_repository.dart';
import '../domain/usecases/agendar_eventos_notificaveis.dart';
import '../domain/usecases/cancelar_eventos_notificaveis.dart';
import '../domain/usecases/detectar_eventos_notificaveis.dart';
import '../domain/usecases/obter_preferencias_notificacao.dart';
import '../domain/usecases/salvar_preferencias_notificacao.dart';
import '../domain/usecases/sincronizar_eventos_notificaveis.dart';

final notificacaoLocalClientProvider = Provider<NotificacaoLocalClient>((ref) {
  return FlutterLocalNotificacaoClient();
});

final preferenciasNotificacaoLocalDataSourceProvider =
    Provider<PreferenciasNotificacaoLocalDataSource>((ref) {
  return const PreferenciasNotificacaoLocalDataSource();
});

final preferenciasNotificacaoRepositoryProvider =
    Provider<PreferenciasNotificacaoRepository>((ref) {
  return PreferenciasNotificacaoRepositoryImpl(
    ref.watch(preferenciasNotificacaoLocalDataSourceProvider),
  );
});

final obterPreferenciasNotificacaoProvider =
    Provider<ObterPreferenciasNotificacao>((ref) {
  return ObterPreferenciasNotificacao(
    ref.watch(preferenciasNotificacaoRepositoryProvider),
  );
});

final salvarPreferenciasNotificacaoProvider =
    Provider<SalvarPreferenciasNotificacao>((ref) {
  return SalvarPreferenciasNotificacao(
    ref.watch(preferenciasNotificacaoRepositoryProvider),
  );
});

final preferenciasNotificacaoProvider = AsyncNotifierProvider<
    PreferenciasNotificacaoController, PreferenciasNotificacaoEntity>(
  PreferenciasNotificacaoController.new,
);

class PreferenciasNotificacaoController
    extends AsyncNotifier<PreferenciasNotificacaoEntity> {
  @override
  Future<PreferenciasNotificacaoEntity> build() {
    return ref.watch(obterPreferenciasNotificacaoProvider).call();
  }

  Future<void> salvar(PreferenciasNotificacaoEntity preferencias) async {
    final anterior = state;
    state = const AsyncLoading<PreferenciasNotificacaoEntity>()
        .copyWithPrevious(anterior);
    state = await AsyncValue.guard(() async {
      await ref.read(salvarPreferenciasNotificacaoProvider).call(preferencias);
      return preferencias;
    });
  }
}

final detectarEventosNotificaveisUseCaseProvider =
    Provider<DetectarEventosNotificaveis>((ref) {
  return DetectarEventosNotificaveis(
    listarProdutosAbaixoMinimo:
        ref.watch(listarProdutosAbaixoMinimoUseCaseProvider),
    listarListasCompras: ref.watch(listarListasComprasUseCaseProvider),
  );
});

final agendarEventosNotificaveisUseCaseProvider =
    Provider<AgendarEventosNotificaveis>((ref) {
  return AgendarEventosNotificaveis(ref.watch(notificacaoLocalClientProvider));
});

final cancelarEventosNotificaveisUseCaseProvider =
    Provider<CancelarEventosNotificaveis>((ref) {
  return CancelarEventosNotificaveis(ref.watch(notificacaoLocalClientProvider));
});

final sincronizarEventosNotificaveisUseCaseProvider =
    Provider<SincronizarEventosNotificaveis>((ref) {
  return SincronizarEventosNotificaveis(
    ref.watch(detectarEventosNotificaveisUseCaseProvider),
    ref.watch(agendarEventosNotificaveisUseCaseProvider),
    ref.watch(cancelarEventosNotificaveisUseCaseProvider),
    ref.watch(notificacaoLocalClientProvider),
  );
});

final eventosNotificaveisProvider =
    FutureProvider<List<EventoNotificavelEntity>>((ref) async {
  final preferencias = await ref.watch(preferenciasNotificacaoProvider.future);
  return ref.watch(detectarEventosNotificaveisUseCaseProvider).call(preferencias);
});
