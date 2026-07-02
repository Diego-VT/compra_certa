import '../entities/estoque_entity.dart';
import '../entities/registrar_movimentacao_estoque_data.dart';
import '../repositories/estoque_repository.dart';

class RegistrarMovimentacaoEstoque {
  const RegistrarMovimentacaoEstoque(this._repository);

  final EstoqueRepository _repository;

  Future<EstoqueEntity> call(RegistrarMovimentacaoEstoqueData movimentacao) {
    return _repository.registrarMovimentacao(movimentacao);
  }
}
