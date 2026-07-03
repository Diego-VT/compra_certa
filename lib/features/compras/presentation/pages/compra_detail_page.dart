import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/compra_providers.dart';
import '../../domain/entities/compra_entity.dart';

class CompraDetailPage extends ConsumerWidget {
  const CompraDetailPage({required this.compraId, super.key});

  final int compraId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compraState = ref.watch(compraPorIdProvider(compraId));

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhe da compra')),
      body: compraState.when(
        data: (compra) {
          if (compra == null) {
            return const Center(child: Text('Compra nao encontrada.'));
          }

          return _CompraDetail(compra: compra);
        },
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Nao foi possivel carregar a compra.\n$error',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _CompraDetail extends StatelessWidget {
  const _CompraDetail({required this.compra});

  final CompraEntity compra;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(_formatDate(compra.dataCompra), style: textTheme.headlineSmall),
        if (compra.observacoes != null) ...[
          const SizedBox(height: 8),
          Text(compra.observacoes!),
        ],
        const SizedBox(height: 16),
        Text('Itens', style: textTheme.titleMedium),
        const SizedBox(height: 8),
        for (final item in compra.itens)
          Card(
            child: ListTile(
              title: Text(item.produtoNome),
              subtitle: Text(
                '${_formatNumber(item.quantidade)} ${item.unidadeMedida}',
              ),
              trailing: Text(_formatItemTotal(item.valorTotal)),
            ),
          ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(2);
  }

  String _formatItemTotal(double? value) {
    if (value == null) {
      return '-';
    }

    return 'R\$ ${value.toStringAsFixed(2)}';
  }
}
