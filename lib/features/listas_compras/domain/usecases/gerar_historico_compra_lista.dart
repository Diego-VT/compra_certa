import '../repositories/lista_compra_repository.dart';

class GerarHistoricoCompraLista {
  const GerarHistoricoCompraLista(this._repository);

  final ListaCompraRepository _repository;

  Future<void> call(int id) {
    return _repository.gerarHistoricoCompra(id);
  }
}
