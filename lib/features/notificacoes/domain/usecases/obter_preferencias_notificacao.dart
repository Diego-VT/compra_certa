import '../entities/preferencias_notificacao_entity.dart';
import '../repositories/preferencias_notificacao_repository.dart';

class ObterPreferenciasNotificacao {
  const ObterPreferenciasNotificacao(this._repository);

  final PreferenciasNotificacaoRepository _repository;

  Future<PreferenciasNotificacaoEntity> call() => _repository.obter();
}
