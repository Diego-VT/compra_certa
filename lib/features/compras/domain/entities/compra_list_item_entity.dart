class CompraListItemEntity {
  const CompraListItemEntity({
    required this.id,
    required this.dataCompra,
    required this.totalItens,
    required this.criadoEm,
    this.valorTotal,
    this.observacoes,
  });

  final int id;
  final DateTime dataCompra;
  final int totalItens;
  final DateTime criadoEm;
  final double? valorTotal;
  final String? observacoes;
}
