class SugestaoRecorrenciaContext {
  const SugestaoRecorrenciaContext({
    required this.produtoId,
    required this.produtoNome,
    required this.unidadeMedida,
    required this.quantidadeAtual,
    required this.quantidadeMinima,
    required this.quantidadeIdeal,
    required this.totalComprasRecentes,
    required this.mediaQuantidade,
    required this.ultimaCompraEm,
  });

  final int produtoId;
  final String produtoNome;
  final String unidadeMedida;
  final double quantidadeAtual;
  final double quantidadeMinima;
  final double quantidadeIdeal;
  final int totalComprasRecentes;
  final double mediaQuantidade;
  final DateTime ultimaCompraEm;
}
