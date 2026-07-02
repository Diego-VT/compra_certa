class CategoriaEntity {
  const CategoriaEntity({
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
}
