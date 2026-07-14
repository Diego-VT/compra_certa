class RelatorioCategoriaItemEntity {
  const RelatorioCategoriaItemEntity({
    required this.categoriaId,
    required this.categoriaNome,
    required this.quantidadeTotal,
    required this.totalProdutos,
    required this.totalRegistros,
    this.valorTotal,
  });

  final int categoriaId;
  final String categoriaNome;
  final double quantidadeTotal;
  final int totalProdutos;
  final int totalRegistros;
  final double? valorTotal;
}
