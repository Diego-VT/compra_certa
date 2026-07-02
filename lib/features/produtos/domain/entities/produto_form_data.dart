class ProdutoFormData {
  const ProdutoFormData({
    required this.nome,
    required this.categoriaId,
    required this.unidadeMedida,
    required this.quantidadeMinima,
    required this.quantidadeIdeal,
    required this.isAtivo,
    this.id,
    this.marca,
    this.observacoes,
  });

  final int? id;
  final String nome;
  final int categoriaId;
  final String unidadeMedida;
  final String? marca;
  final double quantidadeMinima;
  final double quantidadeIdeal;
  final String? observacoes;
  final bool isAtivo;
}
