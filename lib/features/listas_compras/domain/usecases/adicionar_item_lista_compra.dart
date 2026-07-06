import '../entities/lista_compra_form_data.dart';
import '../repositories/lista_compra_repository.dart';

class AdicionarItemListaCompra {
  const AdicionarItemListaCompra(this._repository);

  final ListaCompraRepository _repository;

  Future<void> call(ListaCompraItemFormData data) {
    return _repository.adicionarItem(data);
  }
}
