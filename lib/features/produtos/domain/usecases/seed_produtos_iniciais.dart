import '../repositories/produto_repository.dart';

class SeedProdutosIniciais {
  const SeedProdutosIniciais(this._repository);

  final ProdutoRepository _repository;

  Future<int> call() {
    return _repository.seedProdutosIniciais();
  }
}
