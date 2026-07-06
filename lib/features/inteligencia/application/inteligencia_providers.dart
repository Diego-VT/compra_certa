import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/dependency_providers.dart';
import '../data/datasources/sugestao_inteligente_local_data_source.dart';
import '../data/repositories/sugestao_inteligente_repository_impl.dart';
import '../domain/entities/sugestao_inteligente_entity.dart';
import '../domain/entities/sugestao_inteligente_filtro.dart';
import '../domain/repositories/sugestao_inteligente_repository.dart';
import '../domain/usecases/gerar_sugestoes_locais.dart';

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

final sugestaoInteligenteFiltroProvider =
    StateProvider<SugestaoInteligenteFiltro>((ref) {
      return const SugestaoInteligenteFiltro();
    });

final sugestoesInteligentesProvider =
    FutureProvider<List<SugestaoInteligenteEntity>>((ref) {
      final filtro = ref.watch(sugestaoInteligenteFiltroProvider);

      return ref.watch(gerarSugestoesLocaisUseCaseProvider).call(filtro);
    });
