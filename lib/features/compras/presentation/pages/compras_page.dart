import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_bottom_navigation.dart';
import '../../application/compra_providers.dart';
import '../../domain/entities/compra_filtro.dart';
import '../../domain/entities/compra_list_item_entity.dart';

class ComprasPage extends ConsumerWidget {
  const ComprasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtro = ref.watch(compraFiltroProvider);
    final comprasState = ref.watch(comprasProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de compras')),
      bottomNavigationBar: const AppBottomNavigation(
        currentDestination: AppMainDestination.historico,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.goNamed(AppRoute.novaCompra.name),
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text('Compra'),
      ),
      body: comprasState.when(
        data: (compras) => Column(
          children: [
            _ComprasFilterBar(filtro: filtro),
            Expanded(
              child: _ComprasList(
                compras: compras,
                hasMore: compras.length == filtro.limit,
              ),
            ),
          ],
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Nao foi possivel carregar o historico.\n$error',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _ComprasFilterBar extends ConsumerWidget {
  const _ComprasFilterBar({required this.filtro});

  final CompraFiltro filtro;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            OutlinedButton.icon(
              onPressed: () => _pickInicio(context, ref),
              icon: const Icon(Icons.event_outlined),
              label: Text(_dateLabel('Inicio', filtro.inicio)),
            ),
            OutlinedButton.icon(
              onPressed: () => _pickFim(context, ref),
              icon: const Icon(Icons.event_available_outlined),
              label: Text(_dateLabel('Fim', filtro.fim)),
            ),
            IconButton(
              tooltip: 'Limpar periodo',
              onPressed: filtro.inicio == null && filtro.fim == null
                  ? null
                  : () {
                      ref.read(compraFiltroProvider.notifier).state =
                          const CompraFiltro();
                    },
              icon: const Icon(Icons.filter_alt_off_outlined),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickInicio(BuildContext context, WidgetRef ref) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: filtro.inicio ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: filtro.fim ?? DateTime.now().add(const Duration(days: 1)),
    );

    if (selected == null) {
      return;
    }

    ref.read(compraFiltroProvider.notifier).state = filtro.copyWith(
      inicio: selected,
      limit: 30,
      offset: 0,
    );
  }

  Future<void> _pickFim(BuildContext context, WidgetRef ref) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: filtro.fim ?? DateTime.now(),
      firstDate: filtro.inicio ?? DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );

    if (selected == null) {
      return;
    }

    ref.read(compraFiltroProvider.notifier).state = filtro.copyWith(
      fim: selected,
      limit: 30,
      offset: 0,
    );
  }

  String _dateLabel(String label, DateTime? date) {
    if (date == null) {
      return label;
    }

    return '$label: ${_formatDate(date)}';
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }
}

class _ComprasList extends ConsumerWidget {
  const _ComprasList({required this.compras, required this.hasMore});

  final List<CompraListItemEntity> compras;
  final bool hasMore;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (compras.isEmpty) {
      return const Center(child: Text('Nenhuma compra registrada.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: compras.length + (hasMore ? 1 : 0),
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        if (index == compras.length) {
          return Center(
            child: OutlinedButton.icon(
              onPressed: () {
                final filtro = ref.read(compraFiltroProvider);
                ref.read(compraFiltroProvider.notifier).state = filtro.copyWith(
                  limit: filtro.limit + 30,
                  offset: 0,
                );
              },
              icon: const Icon(Icons.expand_more),
              label: const Text('Carregar mais'),
            ),
          );
        }

        return _CompraCard(compra: compras[index]);
      },
    );
  }
}

class _CompraCard extends StatelessWidget {
  const _CompraCard({required this.compra});

  final CompraListItemEntity compra;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: ListTile(
        leading: const Icon(Icons.receipt_long_outlined),
        title: Text(
          _formatDate(compra.dataCompra),
          style: textTheme.titleMedium,
        ),
        subtitle: Text(
          '${compra.totalItens} item(ns)${_formatTotal(compra.valorTotal)}',
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.goNamed(
          AppRoute.detalheCompra.name,
          pathParameters: {'id': compra.id.toString()},
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  String _formatTotal(double? total) {
    if (total == null) {
      return '';
    }

    return ' - R\$ ${total.toStringAsFixed(2)}';
  }
}
