import '../entities/lista_compra_entity.dart';
import '../entities/lista_compra_filtro.dart';
import '../entities/lista_compra_form_data.dart';
import '../entities/lista_compra_list_item_entity.dart';

abstract class ListaCompraRepository {
  Future<int> criarLista(ListaCompraFormData data);

  Future<ListaCompraEntity?> obterListaPorId(int id);

  Future<List<ListaCompraListItemEntity>> listarListas(
    ListaCompraFiltro filtro,
  );

  Future<void> adicionarItem(ListaCompraItemFormData data);

  Future<void> concluirLista(int id);

  Future<void> gerarHistoricoCompra(int id);

  Future<void> marcarItemComprado({
    required int itemId,
    required bool isComprado,
    required double quantidadeComprada,
  });

  Future<int> gerarListaPorEstoqueBaixo(String nome);
}
