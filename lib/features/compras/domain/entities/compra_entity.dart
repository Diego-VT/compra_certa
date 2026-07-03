import 'compra_item_entity.dart';

class CompraEntity {
  const CompraEntity({
    required this.id,
    required this.dataCompra,
    required this.criadoEm,
    required this.itens,
    this.observacoes,
  });

  final int id;
  final DateTime dataCompra;
  final DateTime criadoEm;
  final String? observacoes;
  final List<CompraItemEntity> itens;

  int get totalItens => itens.length;

  double? get valorTotal {
    var total = 0.0;

    for (final item in itens) {
      final valor = item.valorTotal;

      if (valor == null) {
        return null;
      }

      total += valor;
    }

    return total;
  }
}
