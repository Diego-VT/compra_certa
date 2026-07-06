import '../entities/lista_compra_form_data.dart';
import '../repositories/lista_compra_repository.dart';

class CriarListaCompra {
  const CriarListaCompra(this._repository);

  final ListaCompraRepository _repository;

  Future<int> call(ListaCompraFormData data) {
    return _repository.criarLista(data);
  }
}
