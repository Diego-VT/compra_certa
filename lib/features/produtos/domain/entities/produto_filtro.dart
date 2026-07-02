enum ProdutoStatusFiltro { ativos, inativos, todos }

class ProdutoFiltro {
  const ProdutoFiltro({
    this.busca = '',
    this.categoriaId,
    this.status = ProdutoStatusFiltro.ativos,
  });

  final String busca;
  final int? categoriaId;
  final ProdutoStatusFiltro status;

  ProdutoFiltro copyWith({
    String? busca,
    int? categoriaId,
    bool limparCategoria = false,
    ProdutoStatusFiltro? status,
  }) {
    return ProdutoFiltro(
      busca: busca ?? this.busca,
      categoriaId: limparCategoria ? null : categoriaId ?? this.categoriaId,
      status: status ?? this.status,
    );
  }
}
