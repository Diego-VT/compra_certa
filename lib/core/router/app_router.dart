import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/bootstrap/presentation/bootstrap_page.dart';
import '../../features/categorias/presentation/pages/categorias_page.dart';
import '../../features/compras/presentation/pages/compra_detail_page.dart';
import '../../features/compras/presentation/pages/compra_form_page.dart';
import '../../features/compras/presentation/pages/compras_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/estoque/presentation/pages/ajuste_estoque_page.dart';
import '../../features/estoque/presentation/pages/estoque_page.dart';
import '../../features/inteligencia/presentation/pages/sugestoes_inteligentes_page.dart';
import '../../features/listas_compras/presentation/pages/lista_compra_detail_page.dart';
import '../../features/listas_compras/presentation/pages/lista_compra_form_page.dart';
import '../../features/listas_compras/presentation/pages/listas_compras_page.dart';
import '../../features/notificacoes/presentation/pages/preferencias_notificacao_page.dart';
import '../../features/produtos/presentation/pages/produto_form_page.dart';
import '../../features/produtos/presentation/pages/produtos_page.dart';
import '../../features/relatorios/presentation/pages/relatorios_page.dart';

enum AppRoute {
  bootstrap,
  categorias,
  produtos,
  novoProduto,
  editarProduto,
  dashboard,
  estoque,
  ajustarEstoque,
  compras,
  novaCompra,
  detalheCompra,
  sugestoesInteligentes,
  listasCompras,
  novaListaCompra,
  detalheListaCompra,
  relatorios,
  preferenciasNotificacao,
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/dashboard',
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
        path: '/estoque',
        name: AppRoute.estoque.name,
        builder: (context, state) => const EstoquePage(),
        routes: [
          GoRoute(
            path: ':produtoId/ajustar',
            name: AppRoute.ajustarEstoque.name,
            redirect: (context, state) {
              final produtoId = int.tryParse(
                state.pathParameters['produtoId'] ?? '',
              );

              if (produtoId == null || produtoId <= 0) {
                return '/estoque';
              }

              return null;
            },
            builder: (context, state) {
              final produtoId = int.tryParse(
                state.pathParameters['produtoId'] ?? '',
              );

              return AjusteEstoquePage(produtoId: produtoId!);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/compras',
        name: AppRoute.compras.name,
        builder: (context, state) => const ComprasPage(),
        routes: [
          GoRoute(
            path: 'nova',
            name: AppRoute.novaCompra.name,
            builder: (context, state) => const CompraFormPage(),
          ),
          GoRoute(
            path: ':id',
            name: AppRoute.detalheCompra.name,
            redirect: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '');

              if (id == null || id <= 0) {
                return '/compras';
              }

              return null;
            },
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '');

              return CompraDetailPage(compraId: id!);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/listas-compras',
        name: AppRoute.listasCompras.name,
        builder: (context, state) => const ListasComprasPage(),
        routes: [
          GoRoute(
            path: 'nova',
            name: AppRoute.novaListaCompra.name,
            builder: (context, state) => const ListaCompraFormPage(),
          ),
          GoRoute(
            path: ':id',
            name: AppRoute.detalheListaCompra.name,
            redirect: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '');

              if (id == null || id <= 0) {
                return '/listas-compras';
              }

              return null;
            },
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '');

              return ListaCompraDetailPage(listaId: id!);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/dashboard',
        name: AppRoute.dashboard.name,
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/sugestoes',
        name: AppRoute.sugestoesInteligentes.name,
        builder: (context, state) => const SugestoesInteligentesPage(),
      ),
      GoRoute(
        path: '/relatorios',
        name: AppRoute.relatorios.name,
        builder: (context, state) => const RelatoriosPage(),
      ),
      GoRoute(
        path: '/notificacoes',
        name: AppRoute.preferenciasNotificacao.name,
        builder: (context, state) => const PreferenciasNotificacaoPage(),
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
