class ProdutoSeedModel {
  const ProdutoSeedModel({
    required this.nome,
    required this.categoriaId,
    required this.unidadeMedida,
    required this.quantidadeMinima,
    required this.quantidadeIdeal,
    this.marca,
    this.observacoes,
    this.isAtivo = true,
  });

  final String nome;
  final int categoriaId;
  final String unidadeMedida;
  final String? marca;
  final double quantidadeMinima;
  final double quantidadeIdeal;
  final String? observacoes;
  final bool isAtivo;

  factory ProdutoSeedModel.fromJson(Map<String, dynamic> json) {
    return ProdutoSeedModel(
      nome: json['nome'] as String,
      categoriaId: json['categoriaId'] as int,
      unidadeMedida: json['unidadeMedida'] as String,
      marca: json['marca'] as String?,
      quantidadeMinima: (json['quantidadeMinima'] as num?)?.toDouble() ?? 0,
      quantidadeIdeal: (json['quantidadeIdeal'] as num?)?.toDouble() ?? 0,
      observacoes: json['observacoes'] as String?,
      isAtivo: json['isAtivo'] as bool? ?? true,
    );
  }
}
