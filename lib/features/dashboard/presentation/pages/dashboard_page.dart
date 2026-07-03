import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../compras/domain/entities/compra_list_item_entity.dart';
import '../../../estoque/domain/entities/estoque_entity.dart';
import '../../../listas_compras/domain/entities/lista_compra_list_item_entity.dart';
import '../../application/dashboard_providers.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resumoState = ref.watch(dashboardResumoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Listas de compras',
            onPressed: () => context.goNamed(AppRoute.listasCompras.name),
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
          IconButton(
            tooltip: 'Historico de compras',
            onPressed: () => context.goNamed(AppRoute.compras.name),
            icon: const Icon(Icons.receipt_long_outlined),
          ),
          IconButton(
            tooltip: 'Estoque',
            onPressed: () => context.goNamed(AppRoute.estoque.name),
            icon: const Icon(Icons.inventory_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(dashboardResumoProvider),
        child: resumoState.when(
          data: (resumo) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _ResumoRapidoCard(
                produtosAbaixoMinimo: resumo.produtosAbaixoMinimo.length,
                listasAbertas: resumo.listasAbertas.length,
                comprasRecentes: resumo.comprasRecentes.length,
              ),
              const SizedBox(height: 12),
              _DashboardSectionCard(
                title: 'Produtos abaixo do mínimo',
                value: resumo.produtosAbaixoMinimo.length.toString(),
                subtitle: 'Itens que precisam de reposição',
                icon: Icons.warning_amber_rounded,
                onTap: () => context.goNamed(AppRoute.estoque.name),
                details: _buildProdutosDetails(resumo.produtosAbaixoMinimo),
              ),
              const SizedBox(height: 12),
              _DashboardSectionCard(
                title: 'Listas abertas',
                value: resumo.listasAbertas.length.toString(),
                subtitle: 'Listas em andamento',
                icon: Icons.list_alt_outlined,
                onTap: () => context.goNamed(AppRoute.listasCompras.name),
                details: _buildListasDetails(resumo.listasAbertas),
              ),
              const SizedBox(height: 12),
              _DashboardSectionCard(
                title: 'Compras recentes',
                value: resumo.comprasRecentes.length.toString(),
                subtitle: 'Últimas compras registradas',
                icon: Icons.receipt_long_outlined,
                onTap: () => context.goNamed(AppRoute.compras.name),
                details: _buildComprasDetails(resumo.comprasRecentes),
              ),
            ],
          ),
          error: (error, stackTrace) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _ErrorStateCard(
                message: 'Não foi possível carregar o dashboard',
                detail: error.toString(),
                onRetry: () => ref.invalidate(dashboardResumoProvider),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  List<Widget> _buildProdutosDetails(List<EstoqueEntity> produtos) {
    if (produtos.isEmpty) {
      return const [
        _EmptyState(message: 'Nenhum produto precisa de reposição agora.'),
      ];
    }

    return produtos.take(3).map((produto) {
      return ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.inventory_2_outlined, size: 18),
        title: Text(produto.produtoNome),
        subtitle: Text(
          '${produto.quantidadeAtual.toStringAsFixed(0)} ${produto.unidadeMedida} em estoque · mínimo ${produto.quantidadeMinima.toStringAsFixed(0)}',
        ),
      );
    }).toList();
  }

  List<Widget> _buildListasDetails(List<ListaCompraListItemEntity> listas) {
    if (listas.isEmpty) {
      return const [
        _EmptyState(message: 'Não há listas abertas no momento.'),
      ];
    }

    return listas.take(3).map((lista) {
      return ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.list_alt_outlined, size: 18),
        title: Text(lista.nome),
        subtitle: Text('Itens: ${lista.totalItens} · comprados: ${lista.totalComprados}'),
      );
    }).toList();
  }

  List<Widget> _buildComprasDetails(List<CompraListItemEntity> compras) {
    if (compras.isEmpty) {
      return const [
        _EmptyState(message: 'Nenhuma compra recente registrada.'),
      ];
    }

    return compras.take(3).map((compra) {
      return ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.receipt_long_outlined, size: 18),
        title: Text(
          compra.observacoes?.trim().isNotEmpty == true
              ? compra.observacoes!
              : 'Compra registrada',
        ),
        subtitle: Text('Itens: ${compra.totalItens} · ${_formatDate(compra.dataCompra)}'),
      );
    }).toList();
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'data indisponível';
    }

    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _ResumoRapidoCard extends StatelessWidget {
  const _ResumoRapidoCard({
    required this.produtosAbaixoMinimo,
    required this.listasAbertas,
    required this.comprasRecentes,
  });

  final int produtosAbaixoMinimo;
  final int listasAbertas;
  final int comprasRecentes;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resumo rápido', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              produtosAbaixoMinimo > 0
                  ? 'Atenção: há itens abaixo do mínimo para revisar.'
                  : 'Tudo em ordem no estoque neste momento.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ChipLabel(label: 'Estoque: $produtosAbaixoMinimo'),
                _ChipLabel(label: 'Listas: $listasAbertas'),
                _ChipLabel(label: 'Compras: $comprasRecentes'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChipLabel extends StatelessWidget {
  const _ChipLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _DashboardSectionCard extends StatelessWidget {
  const _DashboardSectionCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.details,
    this.onTap,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final List<Widget> details;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: colorScheme.primaryContainer,
                    child: Icon(icon, color: colorScheme.onPrimaryContainer),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text(subtitle, style: textTheme.bodySmall),
                      ],
                    ),
                  ),
                  Text(value, style: textTheme.headlineSmall),
                ],
              ),
              const SizedBox(height: 12),
              ...details,
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _ErrorStateCard extends StatelessWidget {
  const _ErrorStateCard({
    required this.message,
    required this.detail,
    required this.onRetry,
  });

  final String message;
  final String detail;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.error_outline, color: colorScheme.error),
                const SizedBox(width: 8),
                Expanded(child: Text(message, style: Theme.of(context).textTheme.titleMedium)),
              ],
            ),
            const SizedBox(height: 8),
            Text(detail, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
