import '../entities/sugestao_estoque_context.dart';
import '../entities/sugestao_inteligente_entity.dart';
import '../entities/sugestao_inteligente_filtro.dart';
import '../entities/sugestao_inteligente_tipo.dart';
import '../entities/sugestao_recorrencia_context.dart';

class MotorSugestoesLocais {
  const MotorSugestoesLocais();

  SugestaoInteligenteEntity gerarPorEstoqueBaixo(
    SugestaoEstoqueContext context,
  ) {
    final alvo = context.quantidadeIdeal > context.quantidadeAtual
        ? context.quantidadeIdeal
        : context.quantidadeMinima;
    final quantidadeSugerida = _normalizarQuantidade(
      alvo - context.quantidadeAtual,
    );

    return SugestaoInteligenteEntity(
      tipo: SugestaoInteligenteTipo.estoqueBaixo,
      produtoId: context.produtoId,
      produtoNome: context.produtoNome,
      unidadeMedida: context.unidadeMedida,
      quantidadeAtual: context.quantidadeAtual,
      quantidadeMinima: context.quantidadeMinima,
      quantidadeIdeal: context.quantidadeIdeal,
      quantidadeSugerida: quantidadeSugerida,
      motivo: 'Estoque abaixo do minimo',
      explicacao:
          'Estoque atual ${_formatarNumero(context.quantidadeAtual)} ${context.unidadeMedida}; minimo ${_formatarNumero(context.quantidadeMinima)} e ideal ${_formatarNumero(context.quantidadeIdeal)}.',
    );
  }

  SugestaoInteligenteEntity gerarPorConsumoRecorrente({
    required SugestaoRecorrenciaContext context,
    required SugestaoInteligenteFiltro filtro,
  }) {
    final quantidadeSugerida = _calcularQuantidadeRecorrente(
      quantidadeAtual: context.quantidadeAtual,
      quantidadeIdeal: context.quantidadeIdeal,
      mediaQuantidade: context.mediaQuantidade,
    );

    return SugestaoInteligenteEntity(
      tipo: SugestaoInteligenteTipo.consumoRecorrente,
      produtoId: context.produtoId,
      produtoNome: context.produtoNome,
      unidadeMedida: context.unidadeMedida,
      quantidadeAtual: context.quantidadeAtual,
      quantidadeMinima: context.quantidadeMinima,
      quantidadeIdeal: context.quantidadeIdeal,
      quantidadeSugerida: quantidadeSugerida,
      totalComprasRecentes: context.totalComprasRecentes,
      ultimaCompraEm: context.ultimaCompraEm,
      motivo: 'Consumo recorrente',
      explicacao:
          'Produto apareceu em ${context.totalComprasRecentes} compras nos ultimos ${filtro.janelaRecorrenciaDias} dias; media de ${_formatarNumero(context.mediaQuantidade)} ${context.unidadeMedida} por compra.',
    );
  }

  double _calcularQuantidadeRecorrente({
    required double quantidadeAtual,
    required double quantidadeIdeal,
    required double mediaQuantidade,
  }) {
    if (quantidadeIdeal > quantidadeAtual) {
      return _normalizarQuantidade(quantidadeIdeal - quantidadeAtual);
    }

    return _normalizarQuantidade(mediaQuantidade);
  }

  double _normalizarQuantidade(double value) {
    if (value <= 0) {
      return 1;
    }

    return double.parse(value.toStringAsFixed(2));
  }

  String _formatarNumero(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(2);
  }
}
