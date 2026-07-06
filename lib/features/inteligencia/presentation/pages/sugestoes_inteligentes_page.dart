import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../listas_compras/application/lista_compra_providers.dart';
import '../../../listas_compras/application/listas_compras_paginadas_provider.dart';
import '../../../listas_compras/domain/entities/lista_compra_form_data.dart';
import '../../application/inteligencia_providers.dart';
import '../../domain/entities/sugestao_inteligente_entity.dart';
import '../../domain/entities/sugestao_inteligente_tipo.dart';

class SugestoesInteligentesPage extends ConsumerWidget {
  const SugestoesInteligentesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sugestoesState = ref.watch(sugestoesInteligentesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sugestoes'),
        actions: [
          IconButton(
            tooltip: 'Listas de compras',
            onPressed: () => context.goNamed(AppRoute.listasCompras.name),
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
          IconButton(
            tooltip: 'Atualizar',
            onPressed: () => ref.invalidate(sugestoesInteligentesProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(sugestoesInteligentesProvider),
        child: sugestoesState.when(
          data: (sugestoes) => sugestoes.isEmpty
              ? const _SugestoesEmptyState()
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final sugestao = sugestoes[index];

                    return _SugestaoCard(
                      sugestao: sugestao,
                      onAplicar: () =>
                          _criarListaComSugestao(context, ref, sugestao),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemCount: sugestoes.length,
                ),
          error: (error, stackTrace) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _ErrorStateCard(
                detail: error.toString(),
                onRetry: () => ref.invalidate(sugestoesInteligentesProvider),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  Future<void> _criarListaComSugestao(
    BuildContext context,
    WidgetRef ref,
    SugestaoInteligenteEntity sugestao,
  ) async {
    try {
      final listaId = await ref
          .read(criarListaCompraUseCaseProvider)
          .call(
            ListaCompraFormData(nome: 'Sugestao - ${sugestao.produtoNome}'),
          );

      await ref
          .read(adicionarItemListaCompraUseCaseProvider)
          .call(
            ListaCompraItemFormData(
              listaCompraId: listaId,
              produtoId: sugestao.produtoId,
              quantidadePlanejada: sugestao.quantidadeSugerida,
              observacoes: 'Gerado por sugestao: ${sugestao.motivo}',
            ),
          );

      ref.invalidate(listasComprasProvider);
      ref.read(listasComprasPaginadasProvider.notifier).resetar();

      if (context.mounted) {
        context.goNamed(
          AppRoute.detalheListaCompra.name,
          pathParameters: {'id': listaId.toString()},
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao usar sugestao: $error')),
        );
      }
    }
  }
}

class _SugestaoCard extends StatelessWidget {
  const _SugestaoCard({required this.sugestao, required this.onAplicar});

  final SugestaoInteligenteEntity sugestao;
  final VoidCallback onAplicar;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
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
                  child: Icon(
                    _iconFor(sugestao.tipo),
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sugestao.produtoNome, style: textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(sugestao.motivo, style: textTheme.bodySmall),
                    ],
                  ),
                ),
                Text(
                  '${_formatarNumero(sugestao.quantidadeSugerida)} ${sugestao.unidadeMedida}',
                  style: textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(sugestao.explicacao),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  visualDensity: VisualDensity.compact,
                  label: Text(
                    'Atual: ${_formatarNumero(sugestao.quantidadeAtual)}',
                  ),
                ),
                if (sugestao.quantidadeMinima != null)
                  Chip(
                    visualDensity: VisualDensity.compact,
                    label: Text(
                      'Minimo: ${_formatarNumero(sugestao.quantidadeMinima!)}',
                    ),
                  ),
                if (sugestao.totalComprasRecentes != null)
                  Chip(
                    visualDensity: VisualDensity.compact,
                    label: Text('Compras: ${sugestao.totalComprasRecentes}'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: onAplicar,
                icon: const Icon(Icons.playlist_add_check),
                label: const Text('Criar lista'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(SugestaoInteligenteTipo tipo) {
    return switch (tipo) {
      SugestaoInteligenteTipo.estoqueBaixo => Icons.warning_amber_rounded,
      SugestaoInteligenteTipo.consumoRecorrente => Icons.repeat_rounded,
    };
  }

  String _formatarNumero(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(2);
  }
}

class _SugestoesEmptyState extends StatelessWidget {
  const _SugestoesEmptyState();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  'Nenhuma sugestao agora',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                const Text(
                  'O motor local nao encontrou estoque baixo nem consumo recorrente suficiente para sugerir compras.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorStateCard extends StatelessWidget {
  const _ErrorStateCard({required this.detail, required this.onRetry});

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
                Expanded(
                  child: Text(
                    'Nao foi possivel gerar sugestoes',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
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
