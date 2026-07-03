import '../entities/compra_entity.dart';
import '../repositories/compra_repository.dart';

class ObterCompraPorId {
  const ObterCompraPorId(this._repository);

  final CompraRepository _repository;

  Future<CompraEntity?> call(int id) {
    return _repository.obterCompraPorId(id);
  }
}
