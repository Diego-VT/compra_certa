class RegistrarCompraData {
  const RegistrarCompraData({
    required this.dataCompra,
    required this.itens,
    this.observacoes,
  });

  final DateTime dataCompra;
  final String? observacoes;
  final List<RegistrarCompraItemData> itens;
}

class RegistrarCompraItemData {
  const RegistrarCompraItemData({
    required this.produtoId,
    required this.quantidade,
    this.valorUnitario,
  });

  final int produtoId;
  final double quantidade;
  final double? valorUnitario;
}
