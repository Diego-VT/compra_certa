class ProdutoEntity {
  const ProdutoEntity({
    required this.id,
    required this.nome,
    required this.categoriaId,
    required this.unidadeMedida,
    required this.quantidadeMinima,
    required this.quantidadeIdeal,
    required this.isAtivo,
    required this.criadoEm,
    this.marca,
    this.observacoes,
    this.atualizadoEm,
  });

  final int id;
  final String nome;
  final int categoriaId;
  final String unidadeMedida;
  final String? marca;
  final double quantidadeMinima;
  final double quantidadeIdeal;
  final String? observacoes;
  final bool isAtivo;
  final DateTime criadoEm;
  final DateTime? atualizadoEm;
}
