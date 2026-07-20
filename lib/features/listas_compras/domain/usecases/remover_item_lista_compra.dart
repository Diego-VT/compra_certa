import '../repositories/lista_compra_repository.dart';

class RemoverItemListaCompra {
  const RemoverItemListaCompra(this._repository);

  final ListaCompraRepository _repository;

  Future<void> call(int itemId) {
    return _repository.removerItem(itemId);
  }
}
