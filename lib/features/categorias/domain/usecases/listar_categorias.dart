import '../entities/categoria_entity.dart';
import '../repositories/categoria_repository.dart';

class ListarCategorias {
  const ListarCategorias(this._repository);

  final CategoriaRepository _repository;

  Future<List<CategoriaEntity>> call() {
    return _repository.listarCategorias();
  }
}
