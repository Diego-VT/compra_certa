import 'package:compra_certa/database/app_database.dart';
import 'package:compra_certa/features/relatorios/data/datasources/relatorio_local_data_source.dart';
import 'package:compra_certa/features/relatorios/domain/entities/relatorio_periodo_filtro.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late RelatorioLocalDataSource dataSource;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    dataSource = RelatorioLocalDataSourceImpl(database);

    await database.into(database.categorias).insert(
      CategoriasCompanion(
        id: const Value(1),
        nome: const Value('Alimentos'),
        nivel: const Value(1),
        caminhoCompleto: const Value('Alimentos'),
        origem: const Value('teste'),
      ),
    );
    await database.into(database.categorias).insert(
      CategoriasCompanion(
        id: const Value(2),
        nome: const Value('Bebidas'),
        nivel: const Value(1),
        caminhoCompleto: const Value('Bebidas'),
        origem: const Value('teste'),
      ),
    );

    await _criarProduto(database, nome: 'Arroz', categoriaId: 1);
    await _criarProduto(database, nome: 'Cafe', categoriaId: 1);
    await _criarProduto(database, nome: 'Suco', categoriaId: 2);

    await _registrarCompra(
      database,
      dataCompra: DateTime(2026, 7, 1),
      itens: const [
        _ItemCompra(produtoId: 1, quantidade: 2, valorUnitario: 5),
        _ItemCompra(produtoId: 2, quantidade: 1, valorUnitario: 12),
      ],
    );
    await _registrarCompra(
      database,
      dataCompra: DateTime(2026, 7, 10),
      itens: const [
        _ItemCompra(produtoId: 1, quantidade: 3, valorUnitario: 6),
        _ItemCompra(produtoId: 3, quantidade: 4),
      ],
    );
    await _registrarCompra(
      database,
      dataCompra: DateTime(2026, 5, 1),
      itens: const [_ItemCompra(produtoId: 3, quantidade: 10)],
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('agrega compras por produto e categoria no periodo', () async {
    final relatorio = await dataSource.obterResumo(
      RelatorioPeriodoFiltro(
        inicio: DateTime(2026, 7, 1),
        fim: DateTime(2026, 7, 31),
      ),
    );

    expect(relatorio.periodo.totalCompras, 2);
    expect(relatorio.periodo.totalItens, 4);
    expect(relatorio.periodo.quantidadeTotal, 10);
    expect(relatorio.periodo.valorTotal, isNull);

    expect(relatorio.produtosMaisComprados.first.produtoNome, 'Arroz');
    expect(relatorio.produtosMaisComprados.first.quantidadeTotal, 5);
    expect(relatorio.produtosMaisComprados.first.valorTotal, 28);

    expect(relatorio.consumoPorCategoria.first.categoriaNome, 'Alimentos');
    expect(relatorio.consumoPorCategoria.first.quantidadeTotal, 6);
  });

  test('filtra compras fora do periodo', () async {
    final relatorio = await dataSource.obterResumo(
      RelatorioPeriodoFiltro(
        inicio: DateTime(2026, 5, 1),
        fim: DateTime(2026, 5, 31),
      ),
    );

    expect(relatorio.periodo.totalCompras, 1);
    expect(relatorio.produtosMaisComprados.single.produtoNome, 'Suco');
    expect(relatorio.produtosMaisComprados.single.quantidadeTotal, 10);
  });

  test('retorna vazio quando nao ha compras no periodo', () async {
    final relatorio = await dataSource.obterResumo(
      RelatorioPeriodoFiltro(
        inicio: DateTime(2026, 8, 1),
        fim: DateTime(2026, 8, 31),
      ),
    );

    expect(relatorio.periodo.totalCompras, 0);
    expect(relatorio.periodo.totalItens, 0);
    expect(relatorio.produtosMaisComprados, isEmpty);
    expect(relatorio.consumoPorCategoria, isEmpty);
  });

  test('valida filtro de periodo', () async {
    expect(
      () => dataSource.obterResumo(
        RelatorioPeriodoFiltro(
          inicio: DateTime(2026, 8, 1),
          fim: DateTime(2026, 7, 1),
        ),
      ),
      throwsArgumentError,
    );
  });
}

Future<void> _criarProduto(
  AppDatabase database, {
  required String nome,
  required int categoriaId,
}) {
  return database.into(database.produtos).insert(
        ProdutosCompanion.insert(
          nome: nome,
          categoriaId: categoriaId,
          unidadeMedida: 'un',
          quantidadeMinima: const Value(1),
          quantidadeIdeal: const Value(2),
        ),
      );
}

Future<void> _registrarCompra(
  AppDatabase database, {
  required DateTime dataCompra,
  required List<_ItemCompra> itens,
}) async {
  final compraId = await database
      .into(database.compras)
      .insert(ComprasCompanion.insert(dataCompra: dataCompra));

  for (final item in itens) {
    await database.into(database.itensCompra).insert(
          ItensCompraCompanion.insert(
            compraId: compraId,
            produtoId: item.produtoId,
            quantidade: item.quantidade,
            valorUnitario: Value(item.valorUnitario),
          ),
        );
  }
}

class _ItemCompra {
  const _ItemCompra({
    required this.produtoId,
    required this.quantidade,
    this.valorUnitario,
  });

  final int produtoId;
  final double quantidade;
  final double? valorUnitario;
}
