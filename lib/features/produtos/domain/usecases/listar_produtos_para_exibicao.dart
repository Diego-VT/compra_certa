import '../entities/produto_filtro.dart';
import '../entities/produto_list_item_entity.dart';
import '../repositories/produto_repository.dart';

class ListarProdutosParaExibicao {
  const ListarProdutosParaExibicao(this._repository);

  final ProdutoRepository _repository;

  Future<List<ProdutoListItemEntity>> call(ProdutoFiltro filtro) {
    return _repository.listarProdutosParaExibicao(filtro);
  }
}
