import '../entities/produto_entity.dart';
import '../entities/produto_filtro.dart';
import '../entities/produto_form_data.dart';
import '../entities/produto_list_item_entity.dart';

abstract class ProdutoRepository {
  Future<int> seedProdutosIniciais();

  Future<List<ProdutoEntity>> listarProdutos();

  Future<List<ProdutoListItemEntity>> listarProdutosParaExibicao(
    ProdutoFiltro filtro,
  );

  Future<ProdutoEntity?> buscarProdutoPorId(int id);

  Future<int> salvarProduto(ProdutoFormData produto);

  Future<void> alterarStatusProduto({required int id, required bool isAtivo});
}
