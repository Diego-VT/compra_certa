import 'dart:async';

import 'package:compra_certa/database/app_database.dart';
import 'package:compra_certa/core/di/dependency_providers.dart';
import 'package:compra_certa/features/inteligencia/application/inteligencia_providers.dart';
import 'package:compra_certa/features/inteligencia/domain/entities/sugestao_inteligente_entity.dart';
import 'package:compra_certa/features/inteligencia/domain/entities/sugestao_inteligente_tipo.dart';
import 'package:compra_certa/features/inteligencia/domain/repositories/sugestao_inteligente_repository.dart';
import 'package:compra_certa/features/inteligencia/domain/entities/sugestao_inteligente_filtro.dart';
import 'package:compra_certa/features/inteligencia/presentation/pages/sugestoes_inteligentes_page.dart';
import 'package:compra_certa/services/ia/domain/entities/ia_sugestao_request.dart';
import 'package:compra_certa/services/ia/domain/entities/ia_sugestao_response.dart';
import 'package:compra_certa/services/ia/domain/repositories/ia_client.dart';
import 'package:compra_certa/services/ia/data/datasources/ia_prompt_asset_data_source.dart';
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

  testWidgets('consulta IA opcional apenas por acao do usuario', (tester) async {
    final iaClient = _WidgetIaClient();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sugestaoInteligenteRepositoryProvider.overrideWithValue(
            const _WidgetSugestaoRepository(),
          ),
          iaClientProvider.overrideWithValue(iaClient),
          iaPromptDataSourceProvider.overrideWithValue(
            const _WidgetPromptDataSource(),
          ),
          sugestoesInteligentesProvider.overrideWith(
            (ref) => Future.value(_widgetSugestoes),
          ),
        ],
        child: const MaterialApp(home: SugestoesInteligentesPage()),
      ),
    );

    await tester.pump();

    expect(iaClient.totalChamadas, 0);

    await tester.tap(find.byTooltip('Consultar IA opcional'));
    await tester.pump();
    await tester.pump();

    expect(iaClient.totalChamadas, 1);
    expect(find.text('IA revisou sua lista'), findsOneWidget);
    expect(find.text('Priorize arroz.'), findsOneWidget);
  });

  testWidgets('bloqueia consultas duplicadas enquanto IA esta carregando', (
    tester,
  ) async {
    final iaClient = _SlowWidgetIaClient();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sugestaoInteligenteRepositoryProvider.overrideWithValue(
            const _WidgetSugestaoRepository(),
          ),
          iaClientProvider.overrideWithValue(iaClient),
          sugestoesInteligentesProvider.overrideWith(
            (ref) => Future.value(_widgetSugestoes),
          ),
        ],
        child: const MaterialApp(home: SugestoesInteligentesPage()),
      ),
    );

    await tester.pump();
    await tester.tap(find.byTooltip('Consultar IA opcional'));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.byTooltip('Consultar IA opcional'), warnIfMissed: false);
    await tester.pump();

    expect(iaClient.totalChamadas, 1);

    iaClient.complete();
    await tester.pump();
    await tester.pump();

    expect(find.text('IA revisou sua lista'), findsOneWidget);
  });
}

const _widgetSugestoes = [
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

class _WidgetSugestaoRepository implements SugestaoInteligenteRepository {
  const _WidgetSugestaoRepository();

  @override
  Future<List<SugestaoInteligenteEntity>> gerarSugestoesLocais(
    SugestaoInteligenteFiltro filtro,
  ) async {
    return _widgetSugestoes;
  }
}

class _WidgetIaClient implements IaClient {
  int totalChamadas = 0;

  @override
  Future<IaSugestaoResponse> solicitarSugestao(
    IaSugestaoRequest request,
  ) async {
    totalChamadas++;

    return const IaSugestaoResponse(
      titulo: 'IA revisou sua lista',
      mensagem: 'Priorize arroz.',
    );
  }
}

class _WidgetPromptDataSource implements IaPromptDataSource {
  const _WidgetPromptDataSource();

  @override
  Future<String> carregarPromptSugestoes() async {
    return 'Prompt de teste';
  }
}

class _SlowWidgetIaClient implements IaClient {
  int totalChamadas = 0;
  final Completer<IaSugestaoResponse> _completer =
      Completer<IaSugestaoResponse>();

  @override
  Future<IaSugestaoResponse> solicitarSugestao(
    IaSugestaoRequest request,
  ) {
    totalChamadas++;
    return _completer.future;
  }

  void complete() {
    _completer.complete(
      const IaSugestaoResponse(
        titulo: 'IA revisou sua lista',
        mensagem: 'Priorize arroz.',
      ),
    );
  }
}
