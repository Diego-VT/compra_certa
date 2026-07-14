import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/produto_seed_model.dart';

abstract class ProdutoSeedAssetDataSource {
  Future<List<ProdutoSeedModel>> carregarProdutos();
}

class ProdutoSeedAssetDataSourceImpl implements ProdutoSeedAssetDataSource {
  const ProdutoSeedAssetDataSourceImpl({
    this.assetPath = 'assets/seeds/produtos_seed_compra_certa.json',
  });

  final String assetPath;

  @override
  Future<List<ProdutoSeedModel>> carregarProdutos() async {
    final content = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(content) as Map<String, dynamic>;
    final produtos = decoded['produtos'] as List<dynamic>;

    return produtos
        .cast<Map<String, dynamic>>()
        .map(ProdutoSeedModel.fromJson)
        .toList(growable: false);
  }
}
