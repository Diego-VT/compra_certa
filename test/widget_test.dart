import 'package:compra_certa/app/compra_certa_app.dart';
import 'package:compra_certa/features/categorias/application/categoria_providers.dart';
import 'package:compra_certa/features/produtos/application/produto_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('exibe a tela inicial de produtos', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          categoriasProvider.overrideWith((ref) async => const []),
          produtosListagemProvider.overrideWith((ref) async => const []),
        ],
        child: const CompraCertaApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Produtos'), findsOneWidget);
    expect(find.text('Nenhum produto encontrado.'), findsOneWidget);
  });
}
