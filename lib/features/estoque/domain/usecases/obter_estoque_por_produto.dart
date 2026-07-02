import '../entities/estoque_entity.dart';
import '../repositories/estoque_repository.dart';

class ObterEstoquePorProduto {
  const ObterEstoquePorProduto(this._repository);

  final EstoqueRepository _repository;

  Future<EstoqueEntity?> call(int produtoId) {
    return _repository.obterEstoquePorProduto(produtoId);
  }
}
