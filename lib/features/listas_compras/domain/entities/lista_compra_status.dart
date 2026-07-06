enum ListaCompraStatus {
  aberta('aberta'),
  concluida('concluida');

  const ListaCompraStatus(this.value);

  final String value;

  static ListaCompraStatus fromValue(String value) {
    return ListaCompraStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => ListaCompraStatus.aberta,
    );
  }
}
