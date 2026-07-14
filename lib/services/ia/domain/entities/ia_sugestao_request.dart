import 'ia_sugestao_item_context.dart';

class IaSugestaoRequest {
  const IaSugestaoRequest({
    required this.promptVersion,
    required this.prompt,
    required this.itens,
  });

  final String promptVersion;
  final String prompt;
  final List<IaSugestaoItemContext> itens;

  Map<String, Object> toJson() {
    return {
      'promptVersion': promptVersion,
      'prompt': prompt,
      'itens': itens.map((item) => item.toJson()).toList(growable: false),
    };
  }
}
