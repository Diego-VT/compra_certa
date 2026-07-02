import '../../domain/entities/categoria_entity.dart';
import '../../domain/repositories/categoria_repository.dart';
import '../datasources/categoria_local_data_source.dart';
import '../datasources/categoria_seed_asset_data_source.dart';

class CategoriaRepositoryImpl implements CategoriaRepository {
  const CategoriaRepositoryImpl({
    required this.localDataSource,
    required this.seedAssetDataSource,
  });

  static const seedKey = 'categorias_seed_compra_certa_v1';

  final CategoriaLocalDataSource localDataSource;
  final CategoriaSeedAssetDataSource seedAssetDataSource;

  @override
  Future<int> seedCategoriasIniciais() async {
    final categorias = await seedAssetDataSource.carregarCategorias();

    return localDataSource.executarSeedInicial(
      seedKey: seedKey,
      categorias: categorias,
    );
  }

  @override
  Future<List<CategoriaEntity>> listarCategorias() {
    return localDataSource.listarCategorias();
  }
}
