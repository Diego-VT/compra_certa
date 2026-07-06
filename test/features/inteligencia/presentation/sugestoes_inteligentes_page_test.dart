import 'package:compra_certa/database/app_database.dart';
import 'package:compra_certa/core/di/dependency_providers.dart';
import 'package:compra_certa/features/inteligencia/application/inteligencia_providers.dart';
import 'package:compra_certa/features/inteligencia/domain/entities/sugestao_inteligente_entity.dart';
import 'package:compra_certa/features/inteligencia/domain/entities/sugestao_inteligente_tipo.dart';
import 'package:compra_certa/features/inteligencia/presentation/pages/sugestoes_inteligentes_page.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('exibe sugestoes locais com acao de criar lista', (tester) async {
    const sugestoes = [
      SugestaoInteligenteEntity(
        tipo: SugestaoInteligenteTipo.estoqueBaixo,
        produtoId: 1,
        produtoNome: 'Arroz',
        unidadeMedida: 'kg',
        quantidadeAtual: 1,
        quantidadeMinima: 2,
        quantidadeIdeal: 5,
        quantidadeSugerida: 4,
        motivo: 'Estoque abaixo do minimo',
        explicacao: 'Estoque atual 1 kg; minimo 2 e ideal 5.',
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sugestoesInteligentesProvider.overrideWith(
            (ref) => Future.value(sugestoes),
          ),
        ],
        child: const MaterialApp(home: SugestoesInteligentesPage()),
      ),
    );

    await tester.pump();

    expect(find.text('Arroz'), findsOneWidget);
    expect(find.text('Estoque abaixo do minimo'), findsOneWidget);
    expect(find.text('Criar lista'), findsOneWidget);
  });

  testWidgets('exibe estado vazio quando nao ha sugestoes', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sugestoesInteligentesProvider.overrideWith(
            (ref) => Future.value(const <SugestaoInteligenteEntity>[]),
          ),
        ],
        child: const MaterialApp(home: SugestoesInteligentesPage()),
      ),
    );

    await tester.pump();

    expect(find.text('Nenhuma sugestao agora'), findsOneWidget);
  });

  testWidgets('cria lista de compras a partir da sugestao', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());

    addTearDown(database.close);

    await database
        .into(database.categorias)
        .insert(
          CategoriasCompanion(
            id: const Value(1),
            nome: const Value('Alimentos'),
            nivel: const Value(1),
            caminhoCompleto: const Value('Alimentos'),
            origem: const Value('teste'),
          ),
        );
    await database
        .into(database.produtos)
        .insert(
          ProdutosCompanion.insert(
            nome: 'Arroz',
            categoriaId: 1,
            unidadeMedida: 'kg',
            quantidadeMinima: const Value(2),
            quantidadeIdeal: const Value(5),
          ),
        );

    const sugestoes = [
      SugestaoInteligenteEntity(
        tipo: SugestaoInteligenteTipo.estoqueBaixo,
        produtoId: 1,
        produtoNome: 'Arroz',
        unidadeMedida: 'kg',
        quantidadeAtual: 1,
        quantidadeMinima: 2,
        quantidadeIdeal: 5,
        quantidadeSugerida: 4,
        motivo: 'Estoque abaixo do minimo',
        explicacao: 'Estoque atual 1 kg; minimo 2 e ideal 5.',
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          sugestoesInteligentesProvider.overrideWith(
            (ref) => Future.value(sugestoes),
          ),
        ],
        child: const MaterialApp(home: SugestoesInteligentesPage()),
      ),
    );

    await tester.pump();
    await tester.tap(find.text('Criar lista'));
    await tester.pump();

    final listas = await database.select(database.listasCompras).get();
    final itens = await database.select(database.itensListaCompras).get();

    expect(listas.single.nome, 'Sugestao - Arroz');
    expect(itens.single.produtoId, 1);
    expect(itens.single.quantidadePlanejada, 4);
  });
}
