import '../repositories/produto_repository.dart';

class AlterarStatusProduto {
  const AlterarStatusProduto(this._repository);

  final ProdutoRepository _repository;

  Future<void> call({required int id, required bool isAtivo}) {
    return _repository.alterarStatusProduto(id: id, isAtivo: isAtivo);
  }
}
