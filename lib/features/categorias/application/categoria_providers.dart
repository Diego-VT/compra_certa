import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/dependency_providers.dart';
import '../data/datasources/categoria_local_data_source.dart';
import '../data/datasources/categoria_seed_asset_data_source.dart';
import '../data/repositories/categoria_repository_impl.dart';
import '../domain/entities/categoria_entity.dart';
import '../domain/repositories/categoria_repository.dart';
import '../domain/usecases/listar_categorias.dart';
import '../domain/usecases/seed_categorias_iniciais.dart';

final categoriaSeedAssetDataSourceProvider =
    Provider<CategoriaSeedAssetDataSource>((ref) {
      return const CategoriaSeedAssetDataSourceImpl();
    });

final categoriaLocalDataSourceProvider = Provider<CategoriaLocalDataSource>((
  ref,
) {
  return CategoriaLocalDataSourceImpl(ref.watch(appDatabaseProvider));
});

final categoriaRepositoryProvider = Provider<CategoriaRepository>((ref) {
  return CategoriaRepositoryImpl(
    localDataSource: ref.watch(categoriaLocalDataSourceProvider),
    seedAssetDataSource: ref.watch(categoriaSeedAssetDataSourceProvider),
  );
});

final seedCategoriasIniciaisUseCaseProvider = Provider<SeedCategoriasIniciais>((
  ref,
) {
  return SeedCategoriasIniciais(ref.watch(categoriaRepositoryProvider));
});

final listarCategoriasUseCaseProvider = Provider<ListarCategorias>((ref) {
  return ListarCategorias(ref.watch(categoriaRepositoryProvider));
});

final seedCategoriasIniciaisProvider = FutureProvider<int>((ref) {
  return ref.watch(seedCategoriasIniciaisUseCaseProvider).call();
});

final categoriasProvider = FutureProvider<List<CategoriaEntity>>((ref) async {
  await ref.watch(seedCategoriasIniciaisProvider.future);

  return ref.watch(listarCategoriasUseCaseProvider).call();
});
