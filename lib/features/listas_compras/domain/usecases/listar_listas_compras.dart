import '../entities/lista_compra_filtro.dart';
import '../entities/lista_compra_list_item_entity.dart';
import '../repositories/lista_compra_repository.dart';

class ListarListasCompras {
  const ListarListasCompras(this._repository);

  final ListaCompraRepository _repository;

  Future<List<ListaCompraListItemEntity>> call(ListaCompraFiltro filtro) {
    return _repository.listarListas(filtro);
  }
}
