import '../../../estoque/domain/entities/estoque_entity.dart';
import '../../../compras/domain/entities/compra_list_item_entity.dart';
import '../../../listas_compras/domain/entities/lista_compra_list_item_entity.dart';

class DashboardResumoEntity {
  const DashboardResumoEntity({
    required this.produtosAbaixoMinimo,
    required this.listasAbertas,
    required this.comprasRecentes,
  });

  final List<EstoqueEntity> produtosAbaixoMinimo;
  final List<ListaCompraListItemEntity> listasAbertas;
  final List<CompraListItemEntity> comprasRecentes;
}
