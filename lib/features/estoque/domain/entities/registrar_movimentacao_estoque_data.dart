import 'movimentacao_estoque_tipo.dart';

class RegistrarMovimentacaoEstoqueData {
  const RegistrarMovimentacaoEstoqueData({
    required this.produtoId,
    required this.tipo,
    required this.quantidade,
    this.motivo,
  });

  final int produtoId;
  final MovimentacaoEstoqueTipo tipo;
  final double quantidade;
  final String? motivo;
}
