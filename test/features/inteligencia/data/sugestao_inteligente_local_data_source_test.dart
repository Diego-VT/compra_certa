import 'package:compra_certa/database/app_database.dart';
import 'package:compra_certa/features/inteligencia/data/datasources/sugestao_inteligente_local_data_source.dart';
import 'package:compra_certa/features/inteligencia/domain/entities/sugestao_inteligente_filtro.dart';
import 'package:compra_certa/features/inteligencia/domain/entities/sugestao_inteligente_tipo.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late SugestaoInteligenteLocalDataSource dataSource;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    dataSource = SugestaoInteligenteLocalDataSourceImpl(database);

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

  test('gera sugestao explicavel por estoque abaixo do minimo', () async {
    await _criarProduto(
      database,
      nome: 'Arroz',
      quantidadeMinima: 2,
      quantidadeIdeal: 5,
    );
    await _registrarEstoque(database, produtoId: 1, quantidadeAtual: 1);

    final sugestoes = await dataSource.gerarSugestoesLocais(
      SugestaoInteligenteFiltro(dataReferencia: DateTime(2026, 7, 6)),
    );

    expect(sugestoes, hasLength(1));
    expect(sugestoes.single.tipo, SugestaoInteligenteTipo.estoqueBaixo);
    expect(sugestoes.single.produtoNome, 'Arroz');
    expect(sugestoes.single.quantidadeSugerida, 4);
    expect(sugestoes.single.explicacao, contains('minimo 2'));
  });

  test('gera sugestao por consumo recorrente recente', () async {
    await _criarProduto(
      database,
      nome: 'Cafe',
      quantidadeMinima: 1,
      quantidadeIdeal: 4,
    );
    await _registrarEstoque(database, produtoId: 1, quantidadeAtual: 4);
    await _registrarCompra(
      database,
      produtoId: 1,
      dataCompra: DateTime(2026, 6, 10),
      quantidade: 2,
    );
    await _registrarCompra(
      database,
      produtoId: 1,
      dataCompra: DateTime(2026, 7, 1),
      quantidade: 4,
    );

    final sugestoes = await dataSource.gerarSugestoesLocais(
      SugestaoInteligenteFiltro(dataReferencia: DateTime(2026, 7, 6)),
    );

    expect(sugestoes, hasLength(1));
    expect(sugestoes.single.tipo, SugestaoInteligenteTipo.consumoRecorrente);
    expect(sugestoes.single.produtoNome, 'Cafe');
    expect(sugestoes.single.totalComprasRecentes, 2);
    expect(sugestoes.single.quantidadeSugerida, 3);
  });

  test('ignora produtos inativos nas sugestoes locais', () async {
    await _criarProduto(
      database,
      nome: 'Produto antigo',
      quantidadeMinima: 2,
      quantidadeIdeal: 5,
      isAtivo: false,
    );
    await _registrarEstoque(database, produtoId: 1, quantidadeAtual: 0);
    await _registrarCompra(
      database,
      produtoId: 1,
      dataCompra: DateTime(2026, 7, 1),
      quantidade: 2,
    );
    await _registrarCompra(
      database,
      produtoId: 1,
      dataCompra: DateTime(2026, 7, 3),
      quantidade: 2,
    );

    final sugestoes = await dataSource.gerarSugestoesLocais(
      SugestaoInteligenteFiltro(dataReferencia: DateTime(2026, 7, 6)),
    );

    expect(sugestoes, isEmpty);
  });

  test('retorna vazio quando nao ha dados suficientes', () async {
    final sugestoes = await dataSource.gerarSugestoesLocais(
      SugestaoInteligenteFiltro(dataReferencia: DateTime(2026, 7, 6)),
    );

    expect(sugestoes, isEmpty);
  });

  test('valida filtro para preservar processamento leve', () async {
    expect(
      () => dataSource.gerarSugestoesLocais(
        SugestaoInteligenteFiltro(
          dataReferencia: DateTime(2026, 7, 6),
          limit: 0,
        ),
      ),
      throwsArgumentError,
    );
  });
}

Future<int> _criarProduto(
  AppDatabase database, {
  required String nome,
  required double quantidadeMinima,
  required double quantidadeIdeal,
  bool isAtivo = true,
}) {
  return database
      .into(database.produtos)
      .insert(
        ProdutosCompanion.insert(
          nome: nome,
          categoriaId: 1,
          unidadeMedida: 'un',
          quantidadeMinima: Value(quantidadeMinima),
          quantidadeIdeal: Value(quantidadeIdeal),
          isAtivo: Value(isAtivo),
        ),
      );
}

Future<void> _registrarEstoque(
  AppDatabase database, {
  required int produtoId,
  required double quantidadeAtual,
}) {
  return database
      .into(database.estoques)
      .insert(
        EstoquesCompanion.insert(
          produtoId: produtoId,
          quantidadeAtual: Value(quantidadeAtual),
        ),
      );
}

Future<void> _registrarCompra(
  AppDatabase database, {
  required int produtoId,
  required DateTime dataCompra,
  required double quantidade,
}) async {
  final compraId = await database
      .into(database.compras)
      .insert(ComprasCompanion.insert(dataCompra: dataCompra));

  await database
      .into(database.itensCompra)
      .insert(
        ItensCompraCompanion.insert(
          compraId: compraId,
          produtoId: produtoId,
          quantidade: quantidade,
        ),
      );
}
