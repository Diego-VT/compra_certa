class RelatorioListaCompraItemEntity {
  const RelatorioListaCompraItemEntity({
    required this.produtoNome,
    required this.unidadeMedida,
    required this.quantidadePlanejada,
    required this.quantidadeComprada,
    required this.isComprado,
    this.observacoes,
  });

  final String produtoNome;
  final String unidadeMedida;
  final double quantidadePlanejada;
  final double quantidadeComprada;
  final bool isComprado;
  final String? observacoes;
}
