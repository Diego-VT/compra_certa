import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/dependency_providers.dart';
import '../../../services/ia/data/clients/ia_disabled_client.dart';
import '../../../services/ia/data/datasources/ia_prompt_asset_data_source.dart';
import '../../../services/ia/domain/repositories/ia_client.dart';
import '../data/datasources/sugestao_inteligente_local_data_source.dart';
import '../data/repositories/sugestao_inteligente_repository_impl.dart';
import '../domain/entities/sugestao_inteligente_entity.dart';
import '../domain/entities/sugestao_inteligente_filtro.dart';
import '../domain/repositories/sugestao_inteligente_repository.dart';
import '../domain/usecases/gerar_sugestoes_locais.dart';
import '../domain/usecases/sanitizar_contexto_ia.dart';
import '../domain/usecases/solicitar_sugestao_externa.dart';

final sugestaoInteligenteLocalDataSourceProvider =
    Provider<SugestaoInteligenteLocalDataSource>((ref) {
      return SugestaoInteligenteLocalDataSourceImpl(
        ref.watch(appDatabaseProvider),
      );
    });

final sugestaoInteligenteRepositoryProvider =
    Provider<SugestaoInteligenteRepository>((ref) {
      return SugestaoInteligenteRepositoryImpl(
        localDataSource: ref.watch(sugestaoInteligenteLocalDataSourceProvider),
      );
    });

final gerarSugestoesLocaisUseCaseProvider = Provider<GerarSugestoesLocais>((
  ref,
) {
  return GerarSugestoesLocais(ref.watch(sugestaoInteligenteRepositoryProvider));
});

final iaPromptDataSourceProvider = Provider<IaPromptDataSource>((ref) {
  return const IaPromptAssetDataSource();
});

final iaClientProvider = Provider<IaClient>((ref) {
  return const IaDisabledClient();
});

final sanitizarContextoIaUseCaseProvider = Provider<SanitizarContextoIa>((
  ref,
) {
  return const SanitizarContextoIa();
});

final solicitarSugestaoExternaUseCaseProvider =
    Provider<SolicitarSugestaoExterna>((ref) {
      return SolicitarSugestaoExterna(
        gerarSugestoesLocais: ref.watch(gerarSugestoesLocaisUseCaseProvider),
        sanitizarContextoIa: ref.watch(sanitizarContextoIaUseCaseProvider),
        promptDataSource: ref.watch(iaPromptDataSourceProvider),
        iaClient: ref.watch(iaClientProvider),
      );
    });

final sugestaoInteligenteFiltroProvider =
    StateProvider<SugestaoInteligenteFiltro>((ref) {
      return const SugestaoInteligenteFiltro();
    });

final sugestoesInteligentesProvider =
    FutureProvider<List<SugestaoInteligenteEntity>>((ref) {
      final filtro = ref.watch(sugestaoInteligenteFiltroProvider);

      return ref.watch(gerarSugestoesLocaisUseCaseProvider).call(filtro);
    });
