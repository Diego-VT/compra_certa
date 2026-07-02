import 'movimentacao_estoque_tipo.dart';

class MovimentacaoEstoqueEntity {
  const MovimentacaoEstoqueEntity({
    required this.id,
    required this.produtoId,
    required this.tipo,
    required this.quantidade,
    required this.quantidadeAnterior,
    required this.quantidadeFinal,
    required this.criadoEm,
    this.motivo,
  });

  final int id;
  final int produtoId;
  final MovimentacaoEstoqueTipo tipo;
  final double quantidade;
  final double quantidadeAnterior;
  final double quantidadeFinal;
  final String? motivo;
  final DateTime criadoEm;
}
