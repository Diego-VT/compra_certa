class ListaCompraFormData {
  const ListaCompraFormData({required this.nome});

  final String nome;
}

class ListaCompraItemFormData {
  const ListaCompraItemFormData({
    required this.listaCompraId,
    required this.produtoId,
    required this.quantidadePlanejada,
    this.observacoes,
  });

  final int listaCompraId;
  final int produtoId;
  final double quantidadePlanejada;
  final String? observacoes;
}
