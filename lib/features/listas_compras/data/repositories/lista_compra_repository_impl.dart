import '../../domain/entities/lista_compra_entity.dart';
import '../../domain/entities/lista_compra_filtro.dart';
import '../../domain/entities/lista_compra_form_data.dart';
import '../../domain/entities/lista_compra_list_item_entity.dart';
import '../../domain/repositories/lista_compra_repository.dart';
import '../datasources/lista_compra_local_data_source.dart';

class ListaCompraRepositoryImpl implements ListaCompraRepository {
  const ListaCompraRepositoryImpl({required this.localDataSource});

  final ListaCompraLocalDataSource localDataSource;

  @override
  Future<void> adicionarItem(ListaCompraItemFormData data) {
    return localDataSource.adicionarItem(data);
  }

  @override
  Future<int> criarLista(ListaCompraFormData data) {
    return localDataSource.criarLista(data);
  }

  @override
  Future<void> concluirLista(int id) {
    return localDataSource.concluirLista(id);
  }

  @override
  Future<void> gerarHistoricoCompra(int id) {
    return localDataSource.gerarHistoricoCompra(id);
  }

  @override
  Future<int> gerarListaPorEstoqueBaixo(String nome) {
    return localDataSource.gerarListaPorEstoqueBaixo(nome);
  }

  @override
  Future<List<ListaCompraListItemEntity>> listarListas(
    ListaCompraFiltro filtro,
  ) {
    return localDataSource.listarListas(filtro);
  }

  @override
  Future<void> marcarItemComprado({
    required int itemId,
    required bool isComprado,
    required double quantidadeComprada,
  }) {
    return localDataSource.marcarItemComprado(
      itemId: itemId,
      isComprado: isComprado,
      quantidadeComprada: quantidadeComprada,
    );
  }

  @override
  Future<ListaCompraEntity?> obterListaPorId(int id) {
    return localDataSource.obterListaPorId(id);
  }
}
