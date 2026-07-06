import '../entities/lista_compra_entity.dart';
import '../repositories/lista_compra_repository.dart';

class ObterListaCompraPorId {
  const ObterListaCompraPorId(this._repository);

  final ListaCompraRepository _repository;

  Future<ListaCompraEntity?> call(int id) {
    return _repository.obterListaPorId(id);
  }
}
