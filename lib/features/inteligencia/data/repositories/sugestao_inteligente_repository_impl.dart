import '../../domain/entities/sugestao_inteligente_entity.dart';
import '../../domain/entities/sugestao_inteligente_filtro.dart';
import '../../domain/repositories/sugestao_inteligente_repository.dart';
import '../datasources/sugestao_inteligente_local_data_source.dart';

class SugestaoInteligenteRepositoryImpl
    implements SugestaoInteligenteRepository {
  const SugestaoInteligenteRepositoryImpl({required this.localDataSource});

  final SugestaoInteligenteLocalDataSource localDataSource;

  @override
  Future<List<SugestaoInteligenteEntity>> gerarSugestoesLocais(
    SugestaoInteligenteFiltro filtro,
  ) {
    return localDataSource.gerarSugestoesLocais(filtro);
  }
}
