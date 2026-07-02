class ProdutoListItemEntity {
  const ProdutoListItemEntity({
    required this.id,
    required this.nome,
    required this.categoriaId,
    required this.categoriaNome,
    required this.categoriaCaminho,
    required this.unidadeMedida,
    required this.quantidadeMinima,
    required this.quantidadeIdeal,
    required this.isAtivo,
    this.marca,
  });

  final int id;
  final String nome;
  final int categoriaId;
  final String categoriaNome;
  final String categoriaCaminho;
  final String unidadeMedida;
  final String? marca;
  final double quantidadeMinima;
  final double quantidadeIdeal;
  final bool isAtivo;
}
