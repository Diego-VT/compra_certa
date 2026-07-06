import '../repositories/lista_compra_repository.dart';

class ConcluirListaCompra {
  const ConcluirListaCompra(this._repository);

  final ListaCompraRepository _repository;

  Future<void> call(int id) {
    return _repository.concluirLista(id);
  }
}
