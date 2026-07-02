import '../../domain/entities/produto_entity.dart';
import '../../domain/entities/produto_form_data.dart';
import '../../domain/repositories/produto_repository.dart';
import '../datasources/produto_local_data_source.dart';

class ProdutoRepositoryImpl implements ProdutoRepository {
  const ProdutoRepositoryImpl({required this.localDataSource});

  final ProdutoLocalDataSource localDataSource;

  @override
  Future<ProdutoEntity?> buscarProdutoPorId(int id) {
    return localDataSource.buscarProdutoPorId(id);
  }

  @override
  Future<List<ProdutoEntity>> listarProdutos() {
    return localDataSource.listarProdutos();
  }

  @override
  Future<int> salvarProduto(ProdutoFormData produto) {
    return localDataSource.salvarProduto(produto);
  }
}
