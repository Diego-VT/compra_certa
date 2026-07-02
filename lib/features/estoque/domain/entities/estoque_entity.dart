import 'estoque_status.dart';

class EstoqueEntity {
  const EstoqueEntity({
    required this.produtoId,
    required this.produtoNome,
    required this.unidadeMedida,
    required this.quantidadeAtual,
    required this.quantidadeMinima,
    required this.quantidadeIdeal,
    required this.isProdutoAtivo,
    this.id,
    this.atualizadoEm,
  });

  final int? id;
  final int produtoId;
  final String produtoNome;
  final String unidadeMedida;
  final double quantidadeAtual;
  final double quantidadeMinima;
  final double quantidadeIdeal;
  final bool isProdutoAtivo;
  final DateTime? atualizadoEm;

  EstoqueStatus get status {
    if (quantidadeAtual < quantidadeMinima) {
      return EstoqueStatus.abaixoMinimo;
    }

    if (quantidadeIdeal > 0 && quantidadeAtual > quantidadeIdeal) {
      return EstoqueStatus.acimaIdeal;
    }

    return EstoqueStatus.adequado;
  }
}
