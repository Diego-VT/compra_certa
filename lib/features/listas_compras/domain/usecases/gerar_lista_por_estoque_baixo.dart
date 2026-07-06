import '../repositories/lista_compra_repository.dart';

class GerarListaPorEstoqueBaixo {
  const GerarListaPorEstoqueBaixo(this._repository);

  final ListaCompraRepository _repository;

  Future<int> call(String nome) {
    return _repository.gerarListaPorEstoqueBaixo(nome);
  }
}
