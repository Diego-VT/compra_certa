import 'package:compra_certa/app/compra_certa_app.dart';
import 'package:compra_certa/features/compras/domain/entities/compra_list_item_entity.dart';
import 'package:compra_certa/features/dashboard/application/dashboard_providers.dart';
import 'package:compra_certa/features/dashboard/domain/entities/dashboard_resumo_entity.dart';
import 'package:compra_certa/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:compra_certa/features/estoque/domain/entities/estoque_entity.dart';
import 'package:compra_certa/features/listas_compras/domain/entities/lista_compra_list_item_entity.dart';
import 'package:compra_certa/features/listas_compras/domain/entities/lista_compra_status.dart';
import 'package:compra_certa/features/relatorios/application/relatorio_providers.dart';
import 'package:compra_certa/features/relatorios/domain/entities/relatorio_resumo_entity.dart';
import 'package:compra_certa/features/relatorios/domain/entities/relatorio_resumo_periodo_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('exibe detalhes relevantes no dashboard', (tester) async {
    final resumo = DashboardResumoEntity(
      produtosAbaixoMinimo: const [
        EstoqueEntity(
          produtoId: 1,
          produtoNome: 'Arroz',
          unidadeMedida: 'kg',
          quantidadeAtual: 1,
          quantidadeMinima: 2,
          quantidadeIdeal: 5,
          isProdutoAtivo: true,
        ),
      ],
      listasAbertas: [
        ListaCompraListItemEntity(
          id: 10,
          nome: 'Mercado da semana',
          status: ListaCompraStatus.aberta,
          totalItens: 3,
          totalComprados: 1,
          criadoEm: DateTime(2026, 7, 1),
        ),
      ],
      comprasRecentes: [
        CompraListItemEntity(
          id: 2,
          dataCompra: DateTime(2026, 7, 3),
          totalItens: 2,
          criadoEm: DateTime(2026, 7, 3),
          observacoes: 'Compra semanal',
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dashboardResumoProvider.overrideWith((ref) => Future.value(resumo)),
        ],
        child: const MaterialApp(home: DashboardPage()),
      ),
    );

    await tester.pump();

    expect(find.text('Resumo rápido'), findsOneWidget);
    expect(find.textContaining('Atenção'), findsOneWidget);
    expect(find.text('Arroz'), findsOneWidget);
    expect(find.text('Mercado da semana'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Compra semanal'), 200);
    expect(find.text('Compra semanal'), findsOneWidget);
  });

  testWidgets('navega para relatorios pelo dashboard', (tester) async {
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
          dashboardResumoProvider.overrideWith(
            (ref) => Future.value(
              const DashboardResumoEntity(
                produtosAbaixoMinimo: [],
                listasAbertas: [],
                comprasRecentes: [],
              ),
            ),
          ),
          relatorioResumoProvider.overrideWith((ref) => Future.value(relatorio)),
        ],
        child: const CompraCertaApp(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.byTooltip('Relatorios'));
    await tester.pumpAndSettle();

    expect(find.text('Relatorios'), findsOneWidget);
    expect(
      find.text('Nenhuma compra registrada para o periodo selecionado.'),
      findsOneWidget,
    );
  });
}
