import 'lista_compra_status.dart';

class ListaCompraFiltro {
  const ListaCompraFiltro({
    this.status = ListaCompraStatus.aberta,
    this.limit = 30,
    this.offset = 0,
  });

  final ListaCompraStatus? status;
  final int limit;
  final int offset;

  ListaCompraFiltro copyWith({
    ListaCompraStatus? status,
    int? limit,
    int? offset,
    bool limparStatus = false,
  }) {
    return ListaCompraFiltro(
      status: limparStatus ? null : status ?? this.status,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }
}
