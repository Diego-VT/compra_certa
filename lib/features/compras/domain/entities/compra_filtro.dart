class CompraFiltro {
  const CompraFiltro({this.inicio, this.fim, this.limit = 30, this.offset = 0});

  final DateTime? inicio;
  final DateTime? fim;
  final int limit;
  final int offset;

  CompraFiltro copyWith({
    DateTime? inicio,
    DateTime? fim,
    int? limit,
    int? offset,
    bool limparInicio = false,
    bool limparFim = false,
  }) {
    return CompraFiltro(
      inicio: limparInicio ? null : inicio ?? this.inicio,
      fim: limparFim ? null : fim ?? this.fim,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }
}
