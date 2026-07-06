import '../repositories/lista_compra_repository.dart';

class MarcarItemListaComprado {
  const MarcarItemListaComprado(this._repository);

  final ListaCompraRepository _repository;

  Future<void> call({
    required int itemId,
    required bool isComprado,
    required double quantidadeComprada,
  }) {
    return _repository.marcarItemComprado(
      itemId: itemId,
      isComprado: isComprado,
      quantidadeComprada: quantidadeComprada,
    );
  }
}
