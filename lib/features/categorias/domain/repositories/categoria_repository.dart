import '../entities/categoria_entity.dart';

abstract class CategoriaRepository {
  Future<int> seedCategoriasIniciais();

  Future<List<CategoriaEntity>> listarCategorias();
}
