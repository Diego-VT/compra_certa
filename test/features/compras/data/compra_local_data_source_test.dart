import 'package:compra_certa/database/app_database.dart';
import 'package:compra_certa/features/compras/data/datasources/compra_local_data_source.dart';
import 'package:compra_certa/features/compras/domain/entities/compra_filtro.dart';
import 'package:compra_certa/features/compras/domain/entities/registrar_compra_data.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late CompraLocalDataSource dataSource;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    dataSource = CompraLocalDataSourceImpl(database);

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

    await database
        .into(database.produtos)
        .insert(
          ProdutosCompanion.insert(
            nome: 'Arroz',
            categoriaId: 1,
            unidadeMedida: 'kg',
            quantidadeMinima: const Value(2),
            quantidadeIdeal: const Value(5),
          ),
        );

    await database
        .into(database.produtos)
        .insert(
          ProdutosCompanion.insert(
            nome: 'Cafe',
            categoriaId: 1,
            unidadeMedida: 'un',
            quantidadeMinima: const Value(1),
            quantidadeIdeal: const Value(2),
          ),
        );

    await database
        .into(database.produtos)
        .insert(
          ProdutosCompanion.insert(
            nome: 'Leite',
            categoriaId: 1,
            unidadeMedida: 'un',
            quantidadeMinima: const Value(1),
            quantidadeIdeal: const Value(3),
            isAtivo: const Value(false),
          ),
        );
  });

  tearDown(() async {
    await database.close();
  });

  test('registra compra com itens e permite obter detalhe', () async {
    final compra = await dataSource.registrarCompra(
      RegistrarCompraData(
        dataCompra: DateTime(2026, 7, 3),
        observacoes: 'Compra semanal',
        itens: const [
          RegistrarCompraItemData(
            produtoId: 1,
            quantidade: 2,
            valorUnitario: 6.5,
          ),
          RegistrarCompraItemData(produtoId: 2, quantidade: 1),
        ],
      ),
    );

    expect(compra.id, 1);
    expect(compra.itens, hasLength(2));
    expect(compra.valorTotal, isNull);
    expect(compra.observacoes, 'Compra semanal');

    final detalhe = await dataSource.obterCompraPorId(compra.id);

    expect(detalhe, isNotNull);
    expect(detalhe!.itens.map((item) => item.produtoNome), ['Arroz', 'Cafe']);
  });

  test('lista compras por periodo com total calculado', () async {
    await _registrarCompra(
      dataSource,
      data: DateTime(2026, 7, 1),
      produtoId: 1,
      valorUnitario: 5,
    );
    await _registrarCompra(
      dataSource,
      data: DateTime(2026, 7, 3),
      produtoId: 2,
      valorUnitario: 8,
    );

    final compras = await dataSource.listarComprasPorPeriodo(
      CompraFiltro(inicio: DateTime(2026, 7, 2), fim: DateTime(2026, 7, 4)),
    );

    expect(compras, hasLength(1));
    expect(compras.single.dataCompra, DateTime(2026, 7, 3));
    expect(compras.single.totalItens, 1);
    expect(compras.single.valorTotal, 16);
  });

  test('lista compras com paginacao por compras mais recentes', () async {
    await _registrarCompra(
      dataSource,
      data: DateTime(2026, 7, 1),
      produtoId: 1,
    );
    await _registrarCompra(
      dataSource,
      data: DateTime(2026, 7, 2),
      produtoId: 1,
    );
    await _registrarCompra(
      dataSource,
      data: DateTime(2026, 7, 3),
      produtoId: 1,
    );

    final compras = await dataSource.listarComprasPorPeriodo(
      const CompraFiltro(limit: 1, offset: 1),
    );

    expect(compras, hasLength(1));
    expect(compras.single.dataCompra, DateTime(2026, 7, 2));
  });

  test('mantem paginacao estavel para compras na mesma data', () async {
    await _registrarCompra(
      dataSource,
      data: DateTime(2026, 7, 3),
      produtoId: 1,
    );
    await _registrarCompra(
      dataSource,
      data: DateTime(2026, 7, 3),
      produtoId: 2,
    );

    final primeiraPagina = await dataSource.listarComprasPorPeriodo(
      const CompraFiltro(limit: 1),
    );
    final segundaPagina = await dataSource.listarComprasPorPeriodo(
      const CompraFiltro(limit: 1, offset: 1),
    );

    expect(primeiraPagina.single.id, 2);
    expect(segundaPagina.single.id, 1);
  });

  test('inclui compras feitas durante o dia final do periodo', () async {
    await _registrarCompra(
      dataSource,
      data: DateTime(2026, 7, 3, 18, 30),
      produtoId: 1,
    );

    final compras = await dataSource.listarComprasPorPeriodo(
      CompraFiltro(inicio: DateTime(2026, 7, 3), fim: DateTime(2026, 7, 3)),
    );

    expect(compras, hasLength(1));
  });

  test('bloqueia compra sem itens', () {
    expect(
      () => dataSource.registrarCompra(
        RegistrarCompraData(dataCompra: DateTime(2026, 7, 3), itens: const []),
      ),
      throwsArgumentError,
    );
  });

  test('bloqueia compra com produto inexistente', () async {
    await expectLater(
      dataSource.registrarCompra(
        RegistrarCompraData(
          dataCompra: DateTime(2026, 7, 3),
          itens: const [RegistrarCompraItemData(produtoId: 99, quantidade: 1)],
        ),
      ),
      throwsStateError,
    );
  });

  test('bloqueia compra com produto inativo', () async {
    await expectLater(
      dataSource.registrarCompra(
        RegistrarCompraData(
          dataCompra: DateTime(2026, 7, 3),
          itens: const [RegistrarCompraItemData(produtoId: 3, quantidade: 1)],
        ),
      ),
      throwsStateError,
    );
  });
}

Future<void> _registrarCompra(
  CompraLocalDataSource dataSource, {
  required DateTime data,
  required int produtoId,
  double? valorUnitario,
}) async {
  await dataSource.registrarCompra(
    RegistrarCompraData(
      dataCompra: data,
      itens: [
        RegistrarCompraItemData(
          produtoId: produtoId,
          quantidade: 2,
          valorUnitario: valorUnitario,
        ),
      ],
    ),
  );
}
