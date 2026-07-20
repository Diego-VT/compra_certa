import 'package:compra_certa/features/estoque/domain/entities/estoque_entity.dart';
import 'package:compra_certa/features/estoque/domain/entities/registrar_movimentacao_estoque_data.dart';
import 'package:compra_certa/features/estoque/domain/repositories/estoque_repository.dart';
import 'package:compra_certa/features/estoque/domain/usecases/listar_produtos_abaixo_minimo.dart';
import 'package:compra_certa/features/listas_compras/domain/entities/lista_compra_entity.dart';
import 'package:compra_certa/features/listas_compras/domain/entities/lista_compra_filtro.dart';
import 'package:compra_certa/features/listas_compras/domain/entities/lista_compra_form_data.dart';
import 'package:compra_certa/features/listas_compras/domain/entities/lista_compra_list_item_entity.dart';
import 'package:compra_certa/features/listas_compras/domain/entities/lista_compra_status.dart';
import 'package:compra_certa/features/listas_compras/domain/repositories/lista_compra_repository.dart';
import 'package:compra_certa/features/listas_compras/domain/usecases/listar_listas_compras.dart';
import 'package:compra_certa/features/notificacoes/domain/entities/notificacao_evento_tipo.dart';
import 'package:compra_certa/features/notificacoes/domain/entities/preferencias_notificacao_entity.dart';
import 'package:compra_certa/features/notificacoes/domain/usecases/detectar_eventos_notificaveis.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('detecta eventos de estoque baixo e listas pendentes', () async {
    final useCase = _buildUseCase(
      estoques: [
        _estoque(produtoId: 7, produtoNome: 'Arroz', atual: 1, minima: 3),
      ],
      listas: [
        _lista(id: 4, nome: 'Mercado da semana', totalItens: 5, comprados: 2),
      ],
    );

    final eventos = await useCase.call();

    expect(eventos, hasLength(2));
    expect(eventos.first.tipo, NotificacaoEventoTipo.estoqueBaixo);
    expect(eventos.first.chave, 'estoque_baixo:7');
    expect(eventos.first.notificacaoId, 100007);
    expect(eventos.first.mensagem, contains('Faltam 2 un'));
    expect(eventos.last.tipo, NotificacaoEventoTipo.listaPendente);
    expect(eventos.last.chave, 'lista_pendente:4');
    expect(eventos.last.notificacaoId, 200004);
    expect(eventos.last.mensagem, contains('3 item(ns)'));
  });

  test('respeita preferencia geral desativada', () async {
    final useCase = _buildUseCase(
      estoques: [
        _estoque(produtoId: 1, produtoNome: 'Cafe', atual: 0, minima: 1),
      ],
      listas: [
        _lista(id: 2, nome: 'Compras', totalItens: 1, comprados: 0),
      ],
    );

    final eventos = await useCase.call(
      const PreferenciasNotificacaoEntity(notificacoesAtivas: false),
    );

    expect(eventos, isEmpty);
  });

  test('respeita preferencias por tipo de alerta', () async {
    final useCase = _buildUseCase(
      estoques: [
        _estoque(produtoId: 1, produtoNome: 'Cafe', atual: 0, minima: 1),
      ],
      listas: [
        _lista(id: 2, nome: 'Compras', totalItens: 1, comprados: 0),
      ],
    );

    final eventos = await useCase.call(
      const PreferenciasNotificacaoEntity(alertarListasPendentes: false),
    );

    expect(eventos, hasLength(1));
    expect(eventos.single.tipo, NotificacaoEventoTipo.estoqueBaixo);
  });

  test('ignora lista aberta sem itens pendentes', () async {
    final useCase = _buildUseCase(
      estoques: const [],
      listas: [
        _lista(id: 3, nome: 'Finalizada', totalItens: 2, comprados: 2),
        _lista(id: 4, nome: 'Vazia', totalItens: 0, comprados: 0),
      ],
    );

    expect(await useCase.call(), isEmpty);
  });
}

DetectarEventosNotificaveis _buildUseCase({
  required List<EstoqueEntity> estoques,
  required List<ListaCompraListItemEntity> listas,
}) {
  return DetectarEventosNotificaveis(
    listarProdutosAbaixoMinimo: ListarProdutosAbaixoMinimo(
      _FakeEstoqueRepository(estoques),
    ),
    listarListasCompras: ListarListasCompras(_FakeListaCompraRepository(listas)),
  );
}

EstoqueEntity _estoque({
  required int produtoId,
  required String produtoNome,
  required double atual,
  required double minima,
}) {
  return EstoqueEntity(
    produtoId: produtoId,
    produtoNome: produtoNome,
    unidadeMedida: 'un',
    quantidadeAtual: atual,
    quantidadeMinima: minima,
    quantidadeIdeal: minima + 2,
    isProdutoAtivo: true,
  );
}

ListaCompraListItemEntity _lista({
  required int id,
  required String nome,
  required int totalItens,
  required int comprados,
}) {
  return ListaCompraListItemEntity(
    id: id,
    nome: nome,
    status: ListaCompraStatus.aberta,
    totalItens: totalItens,
    totalComprados: comprados,
    criadoEm: DateTime(2026, 7, 14),
  );
}

class _FakeEstoqueRepository implements EstoqueRepository {
  const _FakeEstoqueRepository(this.estoques);

  final List<EstoqueEntity> estoques;

  @override
  Future<List<EstoqueEntity>> listarProdutosAbaixoMinimo() async {
    return estoques;
  }

  @override
  Future<List<EstoqueEntity>> listarResumoEstoque() {
    throw UnimplementedError();
  }

  @override
  Future<EstoqueEntity?> obterEstoquePorProduto(int produtoId) {
    throw UnimplementedError();
  }

  @override
  Future<EstoqueEntity> registrarMovimentacao(
    RegistrarMovimentacaoEstoqueData movimentacao,
  ) {
    throw UnimplementedError();
  }
}

class _FakeListaCompraRepository implements ListaCompraRepository {
  const _FakeListaCompraRepository(this.listas);

  final List<ListaCompraListItemEntity> listas;

  @override
  Future<List<ListaCompraListItemEntity>> listarListas(
    ListaCompraFiltro filtro,
  ) async {
    return listas
        .where((lista) => filtro.status == null || lista.status == filtro.status)
        .toList();
  }

  @override
  Future<void> adicionarItem(ListaCompraItemFormData data) {
    throw UnimplementedError();
  }

  @override
  Future<void> editarItem(ListaCompraItemUpdateData data) {
    throw UnimplementedError();
  }

  @override
  Future<void> removerItem(int itemId) {
    throw UnimplementedError();
  }

  @override
  Future<void> concluirLista(int id) {
    throw UnimplementedError();
  }

  @override
  Future<int> criarLista(ListaCompraFormData data) {
    throw UnimplementedError();
  }

  @override
  Future<void> gerarHistoricoCompra(int id) {
    throw UnimplementedError();
  }

  @override
  Future<int> gerarListaPorEstoqueBaixo(String nome) {
    throw UnimplementedError();
  }

  @override
  Future<void> marcarItemComprado({
    required int itemId,
    required bool isComprado,
    required double quantidadeComprada,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ListaCompraEntity?> obterListaPorId(int id) {
    throw UnimplementedError();
  }
}
