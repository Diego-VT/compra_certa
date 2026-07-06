import '../entities/sugestao_inteligente_entity.dart';
import '../entities/sugestao_inteligente_filtro.dart';
import '../repositories/sugestao_inteligente_repository.dart';

class GerarSugestoesLocais {
  const GerarSugestoesLocais(this._repository);

  final SugestaoInteligenteRepository _repository;

  Future<List<SugestaoInteligenteEntity>> call([
    SugestaoInteligenteFiltro filtro = const SugestaoInteligenteFiltro(),
  ]) {
    return _repository.gerarSugestoesLocais(filtro);
  }
}
