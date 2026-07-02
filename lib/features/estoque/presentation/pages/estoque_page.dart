import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../application/estoque_providers.dart';
import '../../domain/entities/estoque_entity.dart';
import '../../domain/entities/estoque_status.dart';

enum _EstoqueFiltro { todos, abaixoMinimo }

final _estoqueFiltroProvider = StateProvider<_EstoqueFiltro>((ref) {
  return _EstoqueFiltro.todos;
});

class EstoquePage extends ConsumerWidget {
  const EstoquePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtro = ref.watch(_estoqueFiltroProvider);
    final estoqueState = switch (filtro) {
      _EstoqueFiltro.todos => ref.watch(resumoEstoqueProvider),
      _EstoqueFiltro.abaixoMinimo => ref.watch(produtosAbaixoMinimoProvider),
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estoque'),
        actions: [
          IconButton(
            tooltip: 'Produtos',
            onPressed: () => context.goNamed(AppRoute.produtos.name),
            icon: const Icon(Icons.inventory_2_outlined),
          ),
        ],
      ),
      body: estoqueState.when(
        data: (estoques) => Column(
          children: [
            _EstoqueFilterBar(filtro: filtro),
            Expanded(
              child: _EstoqueList(
                estoques: estoques,
                emptyMessage: filtro == _EstoqueFiltro.abaixoMinimo
                    ? 'Nenhum produto ativo abaixo do minimo.'
                    : 'Nenhum produto para controlar.',
              ),
            ),
          ],
        ),
        error: (error, stackTrace) => _EstoqueError(error: error),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _EstoqueFilterBar extends ConsumerWidget {
  const _EstoqueFilterBar({required this.filtro});

  final _EstoqueFiltro filtro;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: SegmentedButton<_EstoqueFiltro>(
        segments: const [
          ButtonSegment(
            value: _EstoqueFiltro.todos,
            icon: Icon(Icons.inventory_outlined),
            label: Text('Todos'),
          ),
          ButtonSegment(
            value: _EstoqueFiltro.abaixoMinimo,
            icon: Icon(Icons.warning_amber_outlined),
            label: Text('Abaixo do minimo'),
          ),
        ],
        selected: {filtro},
        onSelectionChanged: (selection) {
          ref.read(_estoqueFiltroProvider.notifier).state = selection.single;
        },
      ),
    );
  }
}

class _EstoqueList extends StatelessWidget {
  const _EstoqueList({required this.estoques, required this.emptyMessage});

  final List<EstoqueEntity> estoques;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (estoques.isEmpty) {
      return Center(child: Text(emptyMessage));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: estoques.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final estoque = estoques[index];

        return _EstoqueCard(estoque: estoque);
      },
    );
  }
}

class _EstoqueCard extends StatelessWidget {
  const _EstoqueCard({required this.estoque});

  final EstoqueEntity estoque;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final statusColor = _statusColor(colorScheme);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(estoque.produtoNome, style: textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(
                        _statusLabel(),
                        style: textTheme.bodyMedium?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Ajustar estoque',
                  onPressed: () => context.goNamed(
                    AppRoute.ajustarEstoque.name,
                    pathParameters: {'produtoId': estoque.produtoId.toString()},
                  ),
                  icon: const Icon(Icons.tune),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoChip(
                  icon: Icons.inventory_outlined,
                  label:
                      'Atual: ${_formatNumber(estoque.quantidadeAtual)} ${estoque.unidadeMedida}',
                  color: statusColor,
                ),
                _InfoChip(
                  icon: Icons.remove_circle_outline,
                  label: 'Minima: ${_formatNumber(estoque.quantidadeMinima)}',
                ),
                _InfoChip(
                  icon: Icons.add_circle_outline,
                  label: 'Ideal: ${_formatNumber(estoque.quantidadeIdeal)}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(ColorScheme colorScheme) {
    return switch (estoque.status) {
      EstoqueStatus.abaixoMinimo => colorScheme.error,
      EstoqueStatus.adequado => colorScheme.primary,
      EstoqueStatus.acimaIdeal => colorScheme.tertiary,
    };
  }

  String _statusLabel() {
    return switch (estoque.status) {
      EstoqueStatus.abaixoMinimo => 'Abaixo do minimo',
      EstoqueStatus.adequado => 'Estoque adequado',
      EstoqueStatus.acimaIdeal => 'Acima do ideal',
    };
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(2);
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label, this.color});

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveColor =
        color ?? Theme.of(context).colorScheme.onSurfaceVariant;

    return Chip(
      avatar: Icon(icon, size: 16, color: effectiveColor),
      label: Text(label),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _EstoqueError extends StatelessWidget {
  const _EstoqueError({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Nao foi possivel carregar o estoque.\n$error',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
