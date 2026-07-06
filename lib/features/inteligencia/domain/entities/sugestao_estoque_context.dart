class SugestaoEstoqueContext {
  const SugestaoEstoqueContext({
    required this.produtoId,
    required this.produtoNome,
    required this.unidadeMedida,
    required this.quantidadeAtual,
    required this.quantidadeMinima,
    required this.quantidadeIdeal,
  });

  final int produtoId;
  final String produtoNome;
  final String unidadeMedida;
  final double quantidadeAtual;
  final double quantidadeMinima;
  final double quantidadeIdeal;
}
