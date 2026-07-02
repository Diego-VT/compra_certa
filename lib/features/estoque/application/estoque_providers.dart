import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/dependency_providers.dart';
import '../data/datasources/estoque_local_data_source.dart';
import '../data/repositories/estoque_repository_impl.dart';
import '../domain/entities/estoque_entity.dart';
import '../domain/repositories/estoque_repository.dart';
import '../domain/usecases/listar_produtos_abaixo_minimo.dart';
import '../domain/usecases/listar_resumo_estoque.dart';
import '../domain/usecases/obter_estoque_por_produto.dart';
import '../domain/usecases/registrar_movimentacao_estoque.dart';

final estoqueLocalDataSourceProvider = Provider<EstoqueLocalDataSource>((ref) {
  return EstoqueLocalDataSourceImpl(ref.watch(appDatabaseProvider));
});

final estoqueRepositoryProvider = Provider<EstoqueRepository>((ref) {
  return EstoqueRepositoryImpl(
    localDataSource: ref.watch(estoqueLocalDataSourceProvider),
  );
});

final listarResumoEstoqueUseCaseProvider = Provider<ListarResumoEstoque>((ref) {
  return ListarResumoEstoque(ref.watch(estoqueRepositoryProvider));
});

final obterEstoquePorProdutoUseCaseProvider = Provider<ObterEstoquePorProduto>((
  ref,
) {
  return ObterEstoquePorProduto(ref.watch(estoqueRepositoryProvider));
});

final registrarMovimentacaoEstoqueUseCaseProvider =
    Provider<RegistrarMovimentacaoEstoque>((ref) {
      return RegistrarMovimentacaoEstoque(ref.watch(estoqueRepositoryProvider));
    });

final listarProdutosAbaixoMinimoUseCaseProvider =
    Provider<ListarProdutosAbaixoMinimo>((ref) {
      return ListarProdutosAbaixoMinimo(ref.watch(estoqueRepositoryProvider));
    });

final resumoEstoqueProvider = FutureProvider<List<EstoqueEntity>>((ref) {
  return ref.watch(listarResumoEstoqueUseCaseProvider).call();
});

final produtosAbaixoMinimoProvider = FutureProvider<List<EstoqueEntity>>((ref) {
  return ref.watch(listarProdutosAbaixoMinimoUseCaseProvider).call();
});

final estoquePorProdutoProvider = FutureProvider.family<EstoqueEntity?, int>((
  ref,
  produtoId,
) {
  return ref.watch(obterEstoquePorProdutoUseCaseProvider).call(produtoId);
});
