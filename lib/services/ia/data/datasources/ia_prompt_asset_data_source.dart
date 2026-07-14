import 'package:flutter/services.dart';

abstract class IaPromptDataSource {
  Future<String> carregarPromptSugestoes();
}

class IaPromptAssetDataSource implements IaPromptDataSource {
  const IaPromptAssetDataSource({
    this.assetPath = 'assets/prompts/ia_sugestoes_v1.md',
  });

  final String assetPath;

  @override
  Future<String> carregarPromptSugestoes() {
    return rootBundle.loadString(assetPath);
  }
}
