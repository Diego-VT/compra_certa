import '../entities/estoque_entity.dart';
import '../entities/registrar_movimentacao_estoque_data.dart';

abstract class EstoqueRepository {
  Future<List<EstoqueEntity>> listarResumoEstoque();

  Future<EstoqueEntity?> obterEstoquePorProduto(int produtoId);

  Future<EstoqueEntity> registrarMovimentacao(
    RegistrarMovimentacaoEstoqueData movimentacao,
  );

  Future<List<EstoqueEntity>> listarProdutosAbaixoMinimo();
}
