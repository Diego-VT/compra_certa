import '../entities/preferencias_notificacao_entity.dart';
import '../repositories/preferencias_notificacao_repository.dart';

class SalvarPreferenciasNotificacao {
  const SalvarPreferenciasNotificacao(this._repository);

  final PreferenciasNotificacaoRepository _repository;

  Future<void> call(PreferenciasNotificacaoEntity preferencias) =>
      _repository.salvar(preferencias);
}
