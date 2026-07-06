class ListaCompraItemEntity {
  const ListaCompraItemEntity({
    required this.id,
    required this.listaCompraId,
    required this.produtoId,
    required this.produtoNome,
    required this.unidadeMedida,
    required this.quantidadePlanejada,
    required this.quantidadeComprada,
    required this.isComprado,
    required this.criadoEm,
    this.observacoes,
    this.atualizadoEm,
  });

  final int id;
  final int listaCompraId;
  final int produtoId;
  final String produtoNome;
  final String unidadeMedida;
  final double quantidadePlanejada;
  final double quantidadeComprada;
  final bool isComprado;
  final String? observacoes;
  final DateTime criadoEm;
  final DateTime? atualizadoEm;
}
