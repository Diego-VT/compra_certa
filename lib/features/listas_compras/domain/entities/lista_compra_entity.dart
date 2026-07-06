import 'lista_compra_item_entity.dart';
import 'lista_compra_status.dart';

class ListaCompraEntity {
  const ListaCompraEntity({
    required this.id,
    required this.nome,
    required this.status,
    required this.criadoEm,
    required this.itens,
    this.atualizadoEm,
    this.concluidoEm,
  });

  final int id;
  final String nome;
  final ListaCompraStatus status;
  final DateTime criadoEm;
  final DateTime? atualizadoEm;
  final DateTime? concluidoEm;
  final List<ListaCompraItemEntity> itens;

  int get totalItens => itens.length;

  int get totalComprados {
    return itens.where((item) => item.isComprado).length;
  }
}
