import 'package:compra_certa/database/app_database.dart';
import 'package:compra_certa/features/categorias/data/datasources/categoria_local_data_source.dart';
import 'package:compra_certa/features/categorias/data/models/categoria_seed_model.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late CategoriaLocalDataSource dataSource;

  const categorias = [
    CategoriaSeedModel(
      id: 1,
      nome: 'Alimentos',
      nivel: 1,
      caminhoCompleto: 'Alimentos',
      origem: 'teste',
      isPadrao: true,
      ativo: true,
    ),
    CategoriaSeedModel(
      id: 2,
      nome: 'Carnes',
      categoriaPaiId: 1,
      nivel: 2,
      caminhoCompleto: 'Alimentos > Carnes',
      origem: 'teste',
      isPadrao: true,
      ativo: true,
    ),
  ];

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    dataSource = CategoriaLocalDataSourceImpl(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('executa seed apenas uma vez para a mesma chave', () async {
    final primeiraExecucao = await dataSource.executarSeedInicial(
      seedKey: 'categorias_teste_v1',
      categorias: categorias,
    );
    final segundaExecucao = await dataSource.executarSeedInicial(
      seedKey: 'categorias_teste_v1',
      categorias: categorias,
    );
    final salvas = await dataSource.listarCategorias();

    expect(primeiraExecucao, 2);
    expect(segundaExecucao, 0);
    expect(salvas, hasLength(2));
    expect(salvas.last.categoriaPaiId, 1);
  });

  test('nao duplica categorias por id ou caminho completo', () async {
    await dataSource.executarSeedInicial(
      seedKey: 'categorias_teste_v1',
      categorias: categorias,
    );
    final inseridas = await dataSource.executarSeedInicial(
      seedKey: 'categorias_teste_v2',
      categorias: categorias,
    );
    final salvas = await dataSource.listarCategorias();

    expect(inseridas, 0);
    expect(salvas, hasLength(2));
  });
}
