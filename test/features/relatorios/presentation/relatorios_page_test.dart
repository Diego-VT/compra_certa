import 'package:compra_certa/features/relatorios/application/relatorio_providers.dart';
import 'package:compra_certa/features/relatorios/domain/entities/relatorio_categoria_item_entity.dart';
import 'package:compra_certa/features/relatorios/domain/entities/relatorio_produto_item_entity.dart';
import 'package:compra_certa/features/relatorios/domain/entities/relatorio_resumo_entity.dart';
import 'package:compra_certa/features/relatorios/domain/entities/relatorio_resumo_periodo_entity.dart';
import 'package:compra_certa/features/relatorios/presentation/pages/relatorios_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('exibe resumo de relatorios com produtos e categorias', (
    tester,
  ) async {
    const relatorio = RelatorioResumoEntity(
      periodo: RelatorioResumoPeriodoEntity(
        totalCompras: 2,
        totalItens: 4,
        quantidadeTotal: 10,
        valorTotal: 40,
      ),
      produtosMaisComprados: [
        RelatorioProdutoItemEntity(
          produtoId: 1,
          produtoNome: 'Arroz',
          categoriaNome: 'Alimentos',
          unidadeMedida: 'kg',
          quantidadeTotal: 5,
          totalRegistros: 2,
          valorTotal: 28,
        ),
      ],
      consumoPorCategoria: [
        RelatorioCategoriaItemEntity(
          categoriaId: 1,
          categoriaNome: 'Alimentos',
          quantidadeTotal: 6,
          totalProdutos: 2,
          totalRegistros: 3,
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          relatorioResumoProvider.overrideWith((ref) async => relatorio),
        ],
        child: const MaterialApp(home: RelatoriosPage()),
      ),
    );

    await tester.pump();

    expect(find.text('Relatorios'), findsOneWidget);
    expect(find.text('Resumo'), findsOneWidget);
    expect(find.text('Produtos mais comprados'), findsOneWidget);
    expect(find.text('Arroz'), findsOneWidget);
    expect(find.text('Consumo por categoria'), findsOneWidget);
    expect(find.text('Alimentos'), findsWidgets);
  });

  testWidgets('exibe estado vazio quando nao ha compras', (tester) async {
    const relatorio = RelatorioResumoEntity(
      periodo: RelatorioResumoPeriodoEntity(
        totalCompras: 0,
        totalItens: 0,
        quantidadeTotal: 0,
      ),
      produtosMaisComprados: [],
      consumoPorCategoria: [],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          relatorioResumoProvider.overrideWith((ref) async => relatorio),
        ],
        child: const MaterialApp(home: RelatoriosPage()),
      ),
    );

    await tester.pump();

    expect(
      find.text('Nenhuma compra registrada para o periodo selecionado.'),
      findsOneWidget,
    );
  });
}
