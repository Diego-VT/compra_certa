import '../entities/produto_entity.dart';
import '../repositories/produto_repository.dart';

class BuscarProdutoPorId {
  const BuscarProdutoPorId(this._repository);

  final ProdutoRepository _repository;

  Future<ProdutoEntity?> call(int id) {
    return _repository.buscarProdutoPorId(id);
  }
}
