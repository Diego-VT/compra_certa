import 'package:compra_certa/app/compra_certa_app.dart';
import 'package:compra_certa/features/categorias/application/categoria_providers.dart';
import 'package:compra_certa/features/produtos/application/produto_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('exibe o dashboard como tela inicial', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          categoriasProvider.overrideWith((ref) async => const []),
          produtosListagemProvider.overrideWith((ref) async => const []),
        ],
        child: const CompraCertaApp(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Início'), findsWidgets);
  });
}
