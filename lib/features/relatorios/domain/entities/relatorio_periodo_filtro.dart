class RelatorioPeriodoFiltro {
  const RelatorioPeriodoFiltro({
    this.inicio,
    this.fim,
    this.limit = 10,
  });

  final DateTime? inicio;
  final DateTime? fim;
  final int limit;

  RelatorioPeriodoFiltro copyWith({
    DateTime? inicio,
    DateTime? fim,
    int? limit,
    bool clearInicio = false,
    bool clearFim = false,
  }) {
    return RelatorioPeriodoFiltro(
      inicio: clearInicio ? null : inicio ?? this.inicio,
      fim: clearFim ? null : fim ?? this.fim,
      limit: limit ?? this.limit,
    );
  }
}
