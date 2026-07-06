enum SugestaoInteligenteTipo {
  estoqueBaixo('estoque_baixo'),
  consumoRecorrente('consumo_recorrente');

  const SugestaoInteligenteTipo(this.value);

  final String value;
}
