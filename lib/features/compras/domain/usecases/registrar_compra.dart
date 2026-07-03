import '../entities/compra_entity.dart';
import '../entities/registrar_compra_data.dart';
import '../repositories/compra_repository.dart';

class RegistrarCompra {
  const RegistrarCompra(this._repository);

  final CompraRepository _repository;

  Future<CompraEntity> call(RegistrarCompraData compra) {
    return _repository.registrarCompra(compra);
  }
}
