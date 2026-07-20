import '../entities/lista_compra_form_data.dart';
import '../repositories/lista_compra_repository.dart';

class EditarItemListaCompra {
  const EditarItemListaCompra(this._repository);

  final ListaCompraRepository _repository;

  Future<void> call(ListaCompraItemUpdateData data) {
    return _repository.editarItem(data);
  }
}
