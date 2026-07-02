import '../entities/produto_entity.dart';
import '../repositories/produto_repository.dart';

class ListarProdutos {
  const ListarProdutos(this._repository);

  final ProdutoRepository _repository;

  Future<List<ProdutoEntity>> call() {
    return _repository.listarProdutos();
  }
}
