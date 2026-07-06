class SugestaoInteligenteFiltro {
  const SugestaoInteligenteFiltro({
    this.dataReferencia,
    this.janelaRecorrenciaDias = 60,
    this.minimoComprasRecorrentes = 2,
    this.maxComprasRecentes = 120,
    this.limit = 20,
  });

  final DateTime? dataReferencia;
  final int janelaRecorrenciaDias;
  final int minimoComprasRecorrentes;
  final int maxComprasRecentes;
  final int limit;

  DateTime get referencia => dataReferencia ?? DateTime.now();

  DateTime get inicioRecorrencia {
    final inicio = referencia.subtract(Duration(days: janelaRecorrenciaDias));

    return DateTime(inicio.year, inicio.month, inicio.day);
  }
}
