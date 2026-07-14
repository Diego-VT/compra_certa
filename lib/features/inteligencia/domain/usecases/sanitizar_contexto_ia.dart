import '../../../../services/ia/domain/entities/ia_sugestao_item_context.dart';
import '../entities/sugestao_inteligente_entity.dart';

class SanitizarContextoIa {
  const SanitizarContextoIa({this.maxItens = 5});

  final int maxItens;

  List<IaSugestaoItemContext> call(List<SugestaoInteligenteEntity> sugestoes) {
    if (maxItens <= 0) {
      throw ArgumentError('Limite de itens para IA deve ser maior que zero.');
    }

    return sugestoes
        .take(maxItens)
        .map(
          (sugestao) => IaSugestaoItemContext(
            produtoNome: _limitar(sugestao.produtoNome),
            unidadeMedida: _limitar(sugestao.unidadeMedida, maxLength: 16),
            quantidadeAtual: sugestao.quantidadeAtual,
            quantidadeSugerida: sugestao.quantidadeSugerida,
            motivo: _limitar(sugestao.motivo),
          ),
        )
        .toList(growable: false);
  }

  String _limitar(String value, {int maxLength = 80}) {
    final sanitized = value.trim().replaceAll(RegExp(r'\s+'), ' ');

    if (sanitized.length <= maxLength) {
      return sanitized;
    }

    return sanitized.substring(0, maxLength);
  }
}
