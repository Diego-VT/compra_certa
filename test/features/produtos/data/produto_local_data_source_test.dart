import 'package:compra_certa/database/app_database.dart';
import 'package:compra_certa/features/produtos/data/datasources/produto_local_data_source.dart';
import 'package:compra_certa/features/produtos/domain/entities/produto_form_data.dart';
import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late ProdutoLocalDataSource dataSource;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    dataSource = ProdutoLocalDataSourceImpl(database);

    await database
        .into(database.categorias)
        .insert(
          CategoriasCompanion(
            id: const Value(1),
            nome: const Value('Alimentos'),
            nivel: const Value(1),
            caminhoCompleto: const Value('Alimentos'),
            origem: const Value('teste'),
          ),
        );
  });

  tearDown(() async {
    await database.close();
  });

  test('cadastra produto relacionado a uma categoria', () async {
    final id = await dataSource.salvarProduto(
      const ProdutoFormData(
        nome: 'Arroz',
        categoriaId: 1,
        unidadeMedida: 'kg',
        marca: 'Marca A',
        quantidadeMinima: 1,
        quantidadeIdeal: 3,
        observacoes: 'Integral',
        isAtivo: true,
      ),
    );

    final produtos = await dataSource.listarProdutos();

    expect(id, isPositive);
    expect(produtos, hasLength(1));
    expect(produtos.single.nome, 'Arroz');
    expect(produtos.single.categoriaId, 1);
  });

  test('edita produto existente', () async {
    final id = await dataSource.salvarProduto(
      const ProdutoFormData(
        nome: 'Feijao',
        categoriaId: 1,
        unidadeMedida: 'kg',
        quantidadeMinima: 1,
        quantidadeIdeal: 2,
        isAtivo: true,
      ),
    );

    await dataSource.salvarProduto(
      ProdutoFormData(
        id: id,
        nome: 'Feijao carioca',
        categoriaId: 1,
        unidadeMedida: 'kg',
        quantidadeMinima: 2,
        quantidadeIdeal: 4,
        isAtivo: false,
      ),
    );

    final produto = await dataSource.buscarProdutoPorId(id);

    expect(produto?.nome, 'Feijao carioca');
    expect(produto?.quantidadeIdeal, 4);
    expect(produto?.isAtivo, isFalse);
    expect(produto?.atualizadoEm, isNotNull);
  });
}
