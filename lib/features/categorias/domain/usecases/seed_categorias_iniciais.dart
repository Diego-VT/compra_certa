import '../repositories/categoria_repository.dart';

class SeedCategoriasIniciais {
  const SeedCategoriasIniciais(this._repository);

  final CategoriaRepository _repository;

  Future<int> call() {
    return _repository.seedCategoriasIniciais();
  }
}
