import '../entities/produto_entity.dart';
import '../entities/produto_form_data.dart';

abstract class ProdutoRepository {
  Future<List<ProdutoEntity>> listarProdutos();

  Future<ProdutoEntity?> buscarProdutoPorId(int id);

  Future<int> salvarProduto(ProdutoFormData produto);
}
