import '../entities/sugestao_inteligente_entity.dart';
import '../entities/sugestao_inteligente_filtro.dart';

abstract class SugestaoInteligenteRepository {
  Future<List<SugestaoInteligenteEntity>> gerarSugestoesLocais(
    SugestaoInteligenteFiltro filtro,
  );
}
