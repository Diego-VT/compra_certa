import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/bootstrap/presentation/bootstrap_page.dart';
import '../../features/categorias/presentation/pages/categorias_page.dart';
import '../../features/produtos/presentation/pages/produto_form_page.dart';
import '../../features/produtos/presentation/pages/produtos_page.dart';

enum AppRoute { bootstrap, categorias, produtos, novoProduto, editarProduto }

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/produtos',
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.bootstrap.name,
        builder: (context, state) => const BootstrapPage(),
      ),
      GoRoute(
        path: '/categorias',
        name: AppRoute.categorias.name,
        builder: (context, state) => const CategoriasPage(),
      ),
      GoRoute(
        path: '/produtos',
        name: AppRoute.produtos.name,
        builder: (context, state) => const ProdutosPage(),
        routes: [
          GoRoute(
            path: 'novo',
            name: AppRoute.novoProduto.name,
            builder: (context, state) => const ProdutoFormPage(),
          ),
          GoRoute(
            path: ':id/editar',
            name: AppRoute.editarProduto.name,
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '');

              return ProdutoFormPage(produtoId: id);
            },
          ),
        ],
      ),
    ],
  );

  ref.onDispose(router.dispose);

  return router;
});
