class IaSugestaoItemContext {
  const IaSugestaoItemContext({
    required this.produtoNome,
    required this.unidadeMedida,
    required this.quantidadeAtual,
    required this.quantidadeSugerida,
    required this.motivo,
  });

  final String produtoNome;
  final String unidadeMedida;
  final double quantidadeAtual;
  final double quantidadeSugerida;
  final String motivo;

  Map<String, Object> toJson() {
    return {
      'produtoNome': produtoNome,
      'unidadeMedida': unidadeMedida,
      'quantidadeAtual': quantidadeAtual,
      'quantidadeSugerida': quantidadeSugerida,
      'motivo': motivo,
    };
  }
}
