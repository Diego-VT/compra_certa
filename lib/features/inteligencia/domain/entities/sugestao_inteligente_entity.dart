import 'sugestao_inteligente_tipo.dart';

class SugestaoInteligenteEntity {
  const SugestaoInteligenteEntity({
    required this.tipo,
    required this.produtoId,
    required this.produtoNome,
    required this.unidadeMedida,
    required this.quantidadeAtual,
    required this.quantidadeSugerida,
    required this.motivo,
    required this.explicacao,
    this.quantidadeMinima,
    this.quantidadeIdeal,
    this.totalComprasRecentes,
    this.ultimaCompraEm,
  });

  final SugestaoInteligenteTipo tipo;
  final int produtoId;
  final String produtoNome;
  final String unidadeMedida;
  final double quantidadeAtual;
  final double quantidadeSugerida;
  final double? quantidadeMinima;
  final double? quantidadeIdeal;
  final int? totalComprasRecentes;
  final DateTime? ultimaCompraEm;
  final String motivo;
  final String explicacao;
}
