class CategoriaSeedModel {
  const CategoriaSeedModel({
    required this.id,
    required this.nome,
    required this.nivel,
    required this.caminhoCompleto,
    required this.origem,
    required this.isPadrao,
    required this.ativo,
    this.categoriaPaiId,
  });

  final int id;
  final String nome;
  final int? categoriaPaiId;
  final int nivel;
  final String caminhoCompleto;
  final String origem;
  final bool isPadrao;
  final bool ativo;

  factory CategoriaSeedModel.fromJson(Map<String, dynamic> json) {
    return CategoriaSeedModel(
      id: json['id'] as int,
      nome: json['nome'] as String,
      categoriaPaiId: json['categoriaPaiId'] as int?,
      nivel: json['nivel'] as int,
      caminhoCompleto: json['caminhoCompleto'] as String,
      origem: json['origem'] as String,
      isPadrao: json['isPadrao'] as bool,
      ativo: json['ativo'] as bool,
    );
  }
}
