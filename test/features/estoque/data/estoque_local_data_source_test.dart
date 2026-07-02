import 'package:compra_certa/database/app_database.dart';
import 'package:compra_certa/features/estoque/data/datasources/estoque_local_data_source.dart';
import 'package:compra_certa/features/estoque/domain/entities/estoque_status.dart';
import 'package:compra_certa/features/estoque/domain/entities/movimentacao_estoque_tipo.dart';
import 'package:compra_certa/features/estoque/domain/entities/registrar_movimentacao_estoque_data.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late EstoqueLocalDataSource dataSource;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    dataSource = EstoqueLocalDataSourceImpl(database);

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
            isAtivo: const Value(false),
          ),
        );
  });

  tearDown(() async {
    await database.close();
  });

  test('registra entrada de estoque para produto ativo', () async {
    final estoque = await dataSource.registrarMovimentacao(
      const RegistrarMovimentacaoEstoqueData(
        produtoId: 1,
        tipo: MovimentacaoEstoqueTipo.entrada,
        quantidade: 3,
      ),
    );

    expect(estoque.quantidadeAtual, 3);
    expect(estoque.status, EstoqueStatus.adequado);

    final movimentacoes = await database
        .select(database.movimentacoesEstoque)
        .get();

    expect(movimentacoes, hasLength(1));
    expect(movimentacoes.single.quantidadeAnterior, 0);
    expect(movimentacoes.single.quantidadeFinal, 3);
  });

  test('registra saida sem permitir estoque negativo', () async {
    await dataSource.registrarMovimentacao(
      const RegistrarMovimentacaoEstoqueData(
        produtoId: 1,
        tipo: MovimentacaoEstoqueTipo.entrada,
        quantidade: 3,
      ),
    );

    final estoque = await dataSource.registrarMovimentacao(
      const RegistrarMovimentacaoEstoqueData(
        produtoId: 1,
        tipo: MovimentacaoEstoqueTipo.saida,
        quantidade: 2,
      ),
    );

    expect(estoque.quantidadeAtual, 1);
    expect(estoque.status, EstoqueStatus.abaixoMinimo);

    await expectLater(
      dataSource.registrarMovimentacao(
        const RegistrarMovimentacaoEstoqueData(
          produtoId: 1,
          tipo: MovimentacaoEstoqueTipo.saida,
          quantidade: 2,
        ),
      ),
      throwsStateError,
    );
  });

  test('ajuste define quantidade atual absoluta', () async {
    await dataSource.registrarMovimentacao(
      const RegistrarMovimentacaoEstoqueData(
        produtoId: 1,
        tipo: MovimentacaoEstoqueTipo.entrada,
        quantidade: 3,
      ),
    );

    final estoque = await dataSource.registrarMovimentacao(
      const RegistrarMovimentacaoEstoqueData(
        produtoId: 1,
        tipo: MovimentacaoEstoqueTipo.ajuste,
        quantidade: 6,
        motivo: 'Contagem manual',
      ),
    );

    expect(estoque.quantidadeAtual, 6);
    expect(estoque.status, EstoqueStatus.acimaIdeal);
  });

  test(
    'lista produtos ativos abaixo do minimo incluindo estoque zerado',
    () async {
      final abaixoMinimo = await dataSource.listarProdutosAbaixoMinimo();

      expect(abaixoMinimo.map((estoque) => estoque.produtoNome), ['Arroz']);
    },
  );

  test('nao lista produto ativo com saldo igual ao minimo', () async {
    await dataSource.registrarMovimentacao(
      const RegistrarMovimentacaoEstoqueData(
        produtoId: 1,
        tipo: MovimentacaoEstoqueTipo.entrada,
        quantidade: 2,
      ),
    );

    final abaixoMinimo = await dataSource.listarProdutosAbaixoMinimo();

    expect(abaixoMinimo, isEmpty);
  });

  test('bloqueia movimentacao em produto inativo', () async {
    await expectLater(
      dataSource.registrarMovimentacao(
        const RegistrarMovimentacaoEstoqueData(
          produtoId: 2,
          tipo: MovimentacaoEstoqueTipo.entrada,
          quantidade: 1,
        ),
      ),
      throwsStateError,
    );
  });

  test('bloqueia quantidade negativa', () async {
    expect(
      () => dataSource.registrarMovimentacao(
        const RegistrarMovimentacaoEstoqueData(
          produtoId: 1,
          tipo: MovimentacaoEstoqueTipo.entrada,
          quantidade: -1,
        ),
      ),
      throwsArgumentError,
    );
  });
}
