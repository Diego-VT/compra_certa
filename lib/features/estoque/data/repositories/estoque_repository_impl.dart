import '../../domain/entities/estoque_entity.dart';
import '../../domain/entities/registrar_movimentacao_estoque_data.dart';
import '../../domain/repositories/estoque_repository.dart';
import '../datasources/estoque_local_data_source.dart';

class EstoqueRepositoryImpl implements EstoqueRepository {
  const EstoqueRepositoryImpl({required this.localDataSource});

  final EstoqueLocalDataSource localDataSource;

  @override
  Future<List<EstoqueEntity>> listarProdutosAbaixoMinimo() {
    return localDataSource.listarProdutosAbaixoMinimo();
  }

  @override
  Future<List<EstoqueEntity>> listarResumoEstoque() {
    return localDataSource.listarResumoEstoque();
  }

  @override
  Future<EstoqueEntity?> obterEstoquePorProduto(int produtoId) {
    return localDataSource.obterEstoquePorProduto(produtoId);
  }

  @override
  Future<EstoqueEntity> registrarMovimentacao(
    RegistrarMovimentacaoEstoqueData movimentacao,
  ) {
    return localDataSource.registrarMovimentacao(movimentacao);
  }
}
