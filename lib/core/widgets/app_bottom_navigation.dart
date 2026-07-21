import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router/app_router.dart';

enum AppMainDestination { dashboard, produtos, estoque, listas, historico }

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    required this.currentDestination,
    super.key,
  });

  final AppMainDestination currentDestination;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentDestination.index,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      onDestinationSelected: (index) => _navigate(
        context,
        AppMainDestination.values[index],
      ),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: 'Início',
        ),
        NavigationDestination(
          icon: Icon(Icons.inventory_2_outlined),
          selectedIcon: Icon(Icons.inventory_2),
          label: 'Despensa',
        ),
        NavigationDestination(
          icon: Icon(Icons.inventory_outlined),
          selectedIcon: Icon(Icons.inventory),
          label: 'Estoque',
        ),
        NavigationDestination(
          icon: Icon(Icons.shopping_cart_outlined),
          selectedIcon: Icon(Icons.shopping_cart),
          label: 'Listas',
        ),
        NavigationDestination(
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon: Icon(Icons.receipt_long),
          label: 'Histórico',
        ),
      ],
    );
  }

  void _navigate(BuildContext context, AppMainDestination destination) {
    if (destination == currentDestination) return;

    final route = switch (destination) {
      AppMainDestination.dashboard => AppRoute.dashboard,
      AppMainDestination.produtos => AppRoute.produtos,
      AppMainDestination.estoque => AppRoute.estoque,
      AppMainDestination.listas => AppRoute.listasCompras,
      AppMainDestination.historico => AppRoute.compras,
    };
    context.goNamed(route.name);
  }
}
