import '../entities/produto_form_data.dart';
import '../repositories/produto_repository.dart';

class SalvarProduto {
  const SalvarProduto(this._repository);

  final ProdutoRepository _repository;

  Future<int> call(ProdutoFormData produto) {
    return _repository.salvarProduto(produto);
  }
}
