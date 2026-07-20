import 'package:compra_certa/database/app_database.dart';
import 'package:compra_certa/features/estoque/data/datasources/estoque_local_data_source.dart';
import 'package:compra_certa/features/estoque/domain/entities/movimentacao_estoque_tipo.dart';
import 'package:compra_certa/features/estoque/domain/entities/registrar_movimentacao_estoque_data.dart';
import 'package:compra_certa/features/listas_compras/data/datasources/lista_compra_local_data_source.dart';
import 'package:compra_certa/features/listas_compras/domain/entities/lista_compra_filtro.dart';
import 'package:compra_certa/features/listas_compras/domain/entities/lista_compra_form_data.dart';
import 'package:compra_certa/features/listas_compras/domain/entities/lista_compra_status.dart';
import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late ListaCompraLocalDataSource dataSource;
  late EstoqueLocalDataSource estoqueDataSource;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    dataSource = ListaCompraLocalDataSourceImpl(database);
    estoqueDataSource = EstoqueLocalDataSourceImpl(database);

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
            quantidadeIdeal: const Value(3),
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
            quantidadeIdeal: const Value(2),
            isAtivo: const Value(false),
          ),
        );
  });

  tearDown(() async {
    await database.close();
  });

  test('cria lista e adiciona item ativo', () async {
    final listaId = await dataSource.criarLista(
      const ListaCompraFormData(nome: 'Mercado'),
    );

    await dataSource.adicionarItem(
      const ListaCompraItemFormData(
        listaCompraId: 1,
        produtoId: 1,
        quantidadePlanejada: 2,
      ),
    );

    final lista = await dataSource.obterListaPorId(listaId);

    expect(lista, isNotNull);
    expect(lista!.nome, 'Mercado');
    expect(lista.itens, hasLength(1));
    expect(lista.itens.single.produtoNome, 'Arroz');
  });

  test('bloqueia item duplicado na mesma lista', () async {
    final listaId = await dataSource.criarLista(
      const ListaCompraFormData(nome: 'Mercado'),
    );
    const item = ListaCompraItemFormData(
      listaCompraId: 1,
      produtoId: 1,
      quantidadePlanejada: 2,
    );

    await dataSource.adicionarItem(item);

    await expectLater(dataSource.adicionarItem(item), throwsStateError);
    expect(listaId, 1);
  });

  test('marca item como comprado', () async {
    final listaId = await dataSource.criarLista(
      const ListaCompraFormData(nome: 'Mercado'),
    );
    await dataSource.adicionarItem(
      ListaCompraItemFormData(
        listaCompraId: listaId,
        produtoId: 1,
        quantidadePlanejada: 2,
      ),
    );

    await dataSource.marcarItemComprado(
      itemId: 1,
      isComprado: true,
      quantidadeComprada: 2,
    );

    final lista = await dataSource.obterListaPorId(listaId);

    expect(lista!.totalComprados, 1);
    expect(lista.itens.single.quantidadeComprada, 2);
  });

  test('edita quantidade e observacao do item', () async {
    final listaId = await dataSource.criarLista(
      const ListaCompraFormData(nome: 'Mercado'),
    );
    await dataSource.adicionarItem(
      ListaCompraItemFormData(
        listaCompraId: listaId,
        produtoId: 1,
        quantidadePlanejada: 2,
        observacoes: 'antes',
      ),
    );

    await dataSource.editarItem(
      const ListaCompraItemUpdateData(
        itemId: 1,
        quantidadePlanejada: 4,
        observacoes: 'depois',
      ),
    );

    final lista = await dataSource.obterListaPorId(listaId);

    expect(lista!.itens.single.quantidadePlanejada, 4);
    expect(lista.itens.single.observacoes, 'depois');
    expect(lista.itens.single.atualizadoEm, isNotNull);
  });

  test('remove item da lista aberta', () async {
    final listaId = await dataSource.criarLista(
      const ListaCompraFormData(nome: 'Mercado'),
    );
    await dataSource.adicionarItem(
      ListaCompraItemFormData(
        listaCompraId: listaId,
        produtoId: 1,
        quantidadePlanejada: 2,
      ),
    );

    await dataSource.removerItem(1);

    final lista = await dataSource.obterListaPorId(listaId);

    expect(lista!.itens, isEmpty);
  });

  test('conclui lista e bloqueia alteracao posterior', () async {
    final listaId = await dataSource.criarLista(
      const ListaCompraFormData(nome: 'Mercado'),
    );
    await dataSource.adicionarItem(
      ListaCompraItemFormData(
        listaCompraId: listaId,
        produtoId: 1,
        quantidadePlanejada: 2,
      ),
    );

    await dataSource.concluirLista(listaId);

    final lista = await dataSource.obterListaPorId(listaId);

    expect(lista, isNotNull);
    expect(lista!.status, ListaCompraStatus.concluida);
    expect(lista.concluidoEm, isNotNull);

    await dataSource.gerarHistoricoCompra(listaId);

    final compras = await database.select(database.compras).get();
    expect(compras, hasLength(1));
    expect(compras.single.observacoes, contains('lista'));

    await expectLater(
      dataSource.adicionarItem(
        ListaCompraItemFormData(
          listaCompraId: listaId,
          produtoId: 2,
          quantidadePlanejada: 1,
        ),
      ),
      throwsStateError,
    );
    await expectLater(
      dataSource.editarItem(
        const ListaCompraItemUpdateData(
          itemId: 1,
          quantidadePlanejada: 3,
        ),
      ),
      throwsStateError,
    );
    await expectLater(dataSource.removerItem(1), throwsStateError);
  });

  test('gera lista por produtos abaixo do minimo', () async {
    await estoqueDataSource.registrarMovimentacao(
      const RegistrarMovimentacaoEstoqueData(
        produtoId: 1,
        tipo: MovimentacaoEstoqueTipo.ajuste,
        quantidade: 1,
      ),
    );
    await estoqueDataSource.registrarMovimentacao(
      const RegistrarMovimentacaoEstoqueData(
        produtoId: 2,
        tipo: MovimentacaoEstoqueTipo.ajuste,
        quantidade: 3,
      ),
    );

    final listaId = await dataSource.gerarListaPorEstoqueBaixo('Reposicao');

    final lista = await dataSource.obterListaPorId(listaId);

    expect(lista!.itens, hasLength(1));
    expect(lista.itens.single.produtoNome, 'Arroz');
    expect(lista.itens.single.quantidadePlanejada, 4);
  });

  test('lista com filtro e paginacao', () async {
    await dataSource.criarLista(const ListaCompraFormData(nome: 'Primeira'));
    await dataSource.criarLista(const ListaCompraFormData(nome: 'Segunda'));

    final listas = await dataSource.listarListas(
      const ListaCompraFiltro(limit: 1),
    );

    expect(listas, hasLength(1));
    expect(listas.single.nome, 'Segunda');
  });

  test('bloqueia produto inativo', () async {
    final listaId = await dataSource.criarLista(
      const ListaCompraFormData(nome: 'Mercado'),
    );

    await expectLater(
      dataSource.adicionarItem(
        ListaCompraItemFormData(
          listaCompraId: listaId,
          produtoId: 3,
          quantidadePlanejada: 1,
        ),
      ),
      throwsStateError,
    );
  });
}
