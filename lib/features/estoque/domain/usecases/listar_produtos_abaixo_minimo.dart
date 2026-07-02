import '../entities/estoque_entity.dart';
import '../repositories/estoque_repository.dart';

class ListarProdutosAbaixoMinimo {
  const ListarProdutosAbaixoMinimo(this._repository);

  final EstoqueRepository _repository;

  Future<List<EstoqueEntity>> call() {
    return _repository.listarProdutosAbaixoMinimo();
  }
}
