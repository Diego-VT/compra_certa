import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/categoria_seed_model.dart';

abstract class CategoriaSeedAssetDataSource {
  Future<List<CategoriaSeedModel>> carregarCategorias();
}

class CategoriaSeedAssetDataSourceImpl implements CategoriaSeedAssetDataSource {
  const CategoriaSeedAssetDataSourceImpl({
    this.assetPath = 'assets/seeds/categorias_seed_compra_certa.json',
  });

  final String assetPath;

  @override
  Future<List<CategoriaSeedModel>> carregarCategorias() async {
    final content = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(content) as Map<String, dynamic>;
    final categorias = decoded['categorias'] as List<dynamic>;

    return categorias
        .cast<Map<String, dynamic>>()
        .map(CategoriaSeedModel.fromJson)
        .toList(growable: false);
  }
}
