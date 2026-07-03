class CompraItemEntity {
  const CompraItemEntity({
    required this.id,
    required this.compraId,
    required this.produtoId,
    required this.produtoNome,
    required this.unidadeMedida,
    required this.quantidade,
    this.valorUnitario,
  });

  final int id;
  final int compraId;
  final int produtoId;
  final String produtoNome;
  final String unidadeMedida;
  final double quantidade;
  final double? valorUnitario;

  double? get valorTotal {
    final valor = valorUnitario;

    if (valor == null) {
      return null;
    }

    return valor * quantidade;
  }
}
