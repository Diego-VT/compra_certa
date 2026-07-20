import 'package:compra_certa/core/widgets/app_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('navega entre destinos principais e destaca o atual', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/dashboard',
      routes: [
        GoRoute(
          path: '/dashboard',
          name: 'dashboard',
          builder: (context, state) => const _NavigationTestPage(
            destination: AppMainDestination.dashboard,
          ),
        ),
        GoRoute(
          path: '/produtos',
          name: 'produtos',
          builder: (context, state) => const _NavigationTestPage(
            destination: AppMainDestination.produtos,
          ),
        ),
        GoRoute(path: '/estoque', name: 'estoque', builder: _placeholder),
        GoRoute(
          path: '/listas',
          name: 'listasCompras',
          builder: _placeholder,
        ),
        GoRoute(path: '/compras', name: 'compras', builder: _placeholder),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.inventory_2_outlined));
    await tester.pumpAndSettle();

    expect(router.routeInformationProvider.value.uri.path, '/produtos');
    expect(find.byIcon(Icons.inventory_2), findsOneWidget);
  });
}

Widget _placeholder(BuildContext context, GoRouterState state) {
  return const SizedBox.shrink();
}

class _NavigationTestPage extends StatelessWidget {
  const _NavigationTestPage({required this.destination});

  final AppMainDestination destination;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SizedBox.shrink(),
      bottomNavigationBar: AppBottomNavigation(
        currentDestination: destination,
      ),
    );
  }
}
