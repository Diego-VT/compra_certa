import 'lista_compra_status.dart';
import 'relatorio_lista_compra_item_entity.dart';

class RelatorioListaCompraEntity {
  const RelatorioListaCompraEntity({
    required this.listaId,
    required this.nome,
    required this.status,
    required this.criadoEm,
    required this.geradoEm,
    required this.itens,
    this.concluidoEm,
  });

  final int listaId;
  final String nome;
  final ListaCompraStatus status;
  final DateTime criadoEm;
  final DateTime? concluidoEm;
  final DateTime geradoEm;
  final List<RelatorioListaCompraItemEntity> itens;

  int get totalItens => itens.length;
  int get totalComprados => itens.where((item) => item.isComprado).length;
  int get totalPendentes => totalItens - totalComprados;
  double get percentualConclusao =>
      totalItens == 0 ? 0 : totalComprados / totalItens;
}
