class RelatorioResumoPeriodoEntity {
  const RelatorioResumoPeriodoEntity({
    required this.totalCompras,
    required this.totalItens,
    required this.quantidadeTotal,
    this.valorTotal,
  });

  final int totalCompras;
  final int totalItens;
  final double quantidadeTotal;
  final double? valorTotal;
}
