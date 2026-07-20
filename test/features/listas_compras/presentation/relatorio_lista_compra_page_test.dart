import 'package:compra_certa/features/listas_compras/application/lista_compra_providers.dart';
import 'package:compra_certa/features/listas_compras/domain/entities/lista_compra_status.dart';
import 'package:compra_certa/features/listas_compras/domain/entities/relatorio_lista_compra_entity.dart';
import 'package:compra_certa/features/listas_compras/domain/entities/relatorio_lista_compra_item_entity.dart';
import 'package:compra_certa/features/listas_compras/presentation/pages/relatorio_lista_compra_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('exibe resumo, progresso e itens da lista', (tester) async {
    final relatorio = RelatorioListaCompraEntity(
      listaId: 1,
      nome: 'Mercado da semana',
      status: ListaCompraStatus.aberta,
      criadoEm: DateTime(2026, 7, 20),
      geradoEm: DateTime(2026, 7, 20, 16),
      itens: const [
        RelatorioListaCompraItemEntity(
          produtoNome: 'Arroz',
          unidadeMedida: 'kg',
          quantidadePlanejada: 2,
          quantidadeComprada: 2,
          isComprado: true,
        ),
        RelatorioListaCompraItemEntity(
          produtoNome: 'Cafe',
          unidadeMedida: 'un',
          quantidadePlanejada: 1,
          quantidadeComprada: 0,
          isComprado: false,
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          relatorioListaCompraProvider(
            1,
          ).overrideWith((ref) async => relatorio),
        ],
        child: const MaterialApp(home: RelatorioListaCompraPage(listaId: 1)),
      ),
    );
    await tester.pump();

    expect(find.text('Mercado da semana'), findsOneWidget);
    expect(find.text('50% concluído'), findsOneWidget);
    expect(find.text('1 item(ns) pendente(s)'), findsOneWidget);
    expect(find.text('Arroz'), findsOneWidget);
    expect(find.byTooltip('Compartilhar PDF'), findsOneWidget);
  });
}
