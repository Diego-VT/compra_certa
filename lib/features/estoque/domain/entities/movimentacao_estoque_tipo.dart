enum MovimentacaoEstoqueTipo {
  entrada('entrada'),
  saida('saida'),
  ajuste('ajuste');

  const MovimentacaoEstoqueTipo(this.value);

  final String value;

  static MovimentacaoEstoqueTipo fromValue(String value) {
    return MovimentacaoEstoqueTipo.values.firstWhere(
      (tipo) => tipo.value == value,
      orElse: () => throw ArgumentError('Tipo de movimentacao invalido.'),
    );
  }
}
