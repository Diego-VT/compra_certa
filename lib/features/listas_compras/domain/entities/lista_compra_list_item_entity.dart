import 'lista_compra_status.dart';

class ListaCompraListItemEntity {
  const ListaCompraListItemEntity({
    required this.id,
    required this.nome,
    required this.status,
    required this.totalItens,
    required this.totalComprados,
    required this.criadoEm,
    this.atualizadoEm,
    this.concluidoEm,
  });

  final int id;
  final String nome;
  final ListaCompraStatus status;
  final int totalItens;
  final int totalComprados;
  final DateTime criadoEm;
  final DateTime? atualizadoEm;
  final DateTime? concluidoEm;
}
