import '../entities/compra_filtro.dart';
import '../entities/compra_list_item_entity.dart';
import '../repositories/compra_repository.dart';

class ListarComprasPorPeriodo {
  const ListarComprasPorPeriodo(this._repository);

  final CompraRepository _repository;

  Future<List<CompraListItemEntity>> call(CompraFiltro filtro) {
    return _repository.listarComprasPorPeriodo(filtro);
  }
}
