class RelatorioProdutoItemEntity {
  const RelatorioProdutoItemEntity({
    required this.produtoId,
    required this.produtoNome,
    required this.categoriaNome,
    required this.unidadeMedida,
    required this.quantidadeTotal,
    required this.totalRegistros,
    this.valorTotal,
  });

  final int produtoId;
  final String produtoNome;
  final String categoriaNome;
  final String unidadeMedida;
  final double quantidadeTotal;
  final int totalRegistros;
  final double? valorTotal;
}
