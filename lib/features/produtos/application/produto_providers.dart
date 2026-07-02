import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/dependency_providers.dart';
import '../data/datasources/produto_local_data_source.dart';
import '../data/repositories/produto_repository_impl.dart';
import '../domain/entities/produto_entity.dart';
import '../domain/entities/produto_filtro.dart';
import '../domain/entities/produto_list_item_entity.dart';
import '../domain/repositories/produto_repository.dart';
import '../domain/usecases/alterar_status_produto.dart';
import '../domain/usecases/buscar_produto_por_id.dart';
import '../domain/usecases/listar_produtos.dart';
import '../domain/usecases/listar_produtos_para_exibicao.dart';
import '../domain/usecases/salvar_produto.dart';

final produtoLocalDataSourceProvider = Provider<ProdutoLocalDataSource>((ref) {
  return ProdutoLocalDataSourceImpl(ref.watch(appDatabaseProvider));
});

final produtoRepositoryProvider = Provider<ProdutoRepository>((ref) {
  return ProdutoRepositoryImpl(
    localDataSource: ref.watch(produtoLocalDataSourceProvider),
  );
});

final listarProdutosUseCaseProvider = Provider<ListarProdutos>((ref) {
  return ListarProdutos(ref.watch(produtoRepositoryProvider));
});

final listarProdutosParaExibicaoUseCaseProvider =
    Provider<ListarProdutosParaExibicao>((ref) {
      return ListarProdutosParaExibicao(ref.watch(produtoRepositoryProvider));
    });

final buscarProdutoPorIdUseCaseProvider = Provider<BuscarProdutoPorId>((ref) {
  return BuscarProdutoPorId(ref.watch(produtoRepositoryProvider));
});

final salvarProdutoUseCaseProvider = Provider<SalvarProduto>((ref) {
  return SalvarProduto(ref.watch(produtoRepositoryProvider));
});

final alterarStatusProdutoUseCaseProvider = Provider<AlterarStatusProduto>((
  ref,
) {
  return AlterarStatusProduto(ref.watch(produtoRepositoryProvider));
});

final produtoFiltroProvider = StateProvider<ProdutoFiltro>((ref) {
  return const ProdutoFiltro();
});

final produtosProvider = FutureProvider<List<ProdutoEntity>>((ref) {
  return ref.watch(listarProdutosUseCaseProvider).call();
});

final produtosListagemProvider = FutureProvider<List<ProdutoListItemEntity>>((
  ref,
) {
  final filtro = ref.watch(produtoFiltroProvider);

  return ref.watch(listarProdutosParaExibicaoUseCaseProvider).call(filtro);
});

final produtoPorIdProvider = FutureProvider.family<ProdutoEntity?, int>((
  ref,
  id,
) {
  return ref.watch(buscarProdutoPorIdUseCaseProvider).call(id);
});
