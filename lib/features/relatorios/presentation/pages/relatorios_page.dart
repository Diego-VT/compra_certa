import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/relatorio_providers.dart';
import '../../domain/entities/relatorio_categoria_item_entity.dart';
import '../../domain/entities/relatorio_periodo_filtro.dart';
import '../../domain/entities/relatorio_produto_item_entity.dart';
import '../../domain/entities/relatorio_resumo_entity.dart';

class RelatoriosPage extends ConsumerWidget {
  const RelatoriosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relatorioState = ref.watch(relatorioResumoProvider);
    final filtro = ref.watch(relatorioFiltroProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatorios'),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            onPressed: () => ref.invalidate(relatorioResumoProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(relatorioResumoProvider),
        child: relatorioState.when(
          data: (relatorio) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _PeriodoFilterCard(filtro: filtro),
              const SizedBox(height: 12),
              if (_isEmpty(relatorio))
                const _EmptyRelatorioCard()
              else ...[
                _ResumoPeriodoCard(relatorio: relatorio),
                const SizedBox(height: 12),
                _ProdutosMaisCompradosCard(
                  produtos: relatorio.produtosMaisComprados,
                ),
                const SizedBox(height: 12),
                _ConsumoPorCategoriaCard(
                  categorias: relatorio.consumoPorCategoria,
                ),
              ],
            ],
          ),
          error: (error, stackTrace) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _ErrorStateCard(
                detail: error.toString(),
                onRetry: () => ref.invalidate(relatorioResumoProvider),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  bool _isEmpty(RelatorioResumoEntity relatorio) {
    return relatorio.periodo.totalCompras == 0 &&
        relatorio.produtosMaisComprados.isEmpty &&
        relatorio.consumoPorCategoria.isEmpty;
  }
}

class _PeriodoFilterCard extends ConsumerWidget {
  const _PeriodoFilterCard({required this.filtro});

  final RelatorioPeriodoFiltro filtro;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Periodo', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              _periodoLabel(filtro),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  label: const Text('30 dias'),
                  selected: _isSelected(filtro, 30),
                  onSelected: (_) => _setPeriodo(ref, 30),
                ),
                FilterChip(
                  label: const Text('90 dias'),
                  selected: _isSelected(filtro, 90),
                  onSelected: (_) => _setPeriodo(ref, 90),
                ),
                FilterChip(
                  label: const Text('Todo periodo'),
                  selected: filtro.inicio == null && filtro.fim == null,
                  onSelected: (_) => ref
                      .read(relatorioFiltroProvider.notifier)
                      .state = const RelatorioPeriodoFiltro(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _isSelected(RelatorioPeriodoFiltro filtro, int dias) {
    final inicio = filtro.inicio;
    final fim = filtro.fim;

    if (inicio == null || fim == null) {
      return false;
    }

    final inicioNormalizado = DateTime(inicio.year, inicio.month, inicio.day);
    final fimNormalizado = DateTime(fim.year, fim.month, fim.day);

    return fimNormalizado.difference(inicioNormalizado).inDays == dias - 1;
  }

  void _setPeriodo(WidgetRef ref, int dias) {
    final hoje = DateTime.now();
    final fim = DateTime(hoje.year, hoje.month, hoje.day);

    ref.read(relatorioFiltroProvider.notifier).state = RelatorioPeriodoFiltro(
      inicio: fim.subtract(Duration(days: dias - 1)),
      fim: fim,
    );
  }

  String _periodoLabel(RelatorioPeriodoFiltro filtro) {
    final inicio = filtro.inicio;
    final fim = filtro.fim;

    if (inicio == null && fim == null) {
      return 'Considerando todo o historico registrado.';
    }

    return '${_formatDate(inicio)} ate ${_formatDate(fim)}';
  }
}

class _ResumoPeriodoCard extends StatelessWidget {
  const _ResumoPeriodoCard({required this.relatorio});

  final RelatorioResumoEntity relatorio;

  @override
  Widget build(BuildContext context) {
    final periodo = relatorio.periodo;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resumo', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _MetricChip(label: 'Compras', value: '${periodo.totalCompras}'),
                _MetricChip(label: 'Itens', value: '${periodo.totalItens}'),
                _MetricChip(
                  label: 'Quantidade',
                  value: _formatNumber(periodo.quantidadeTotal),
                ),
                _MetricChip(
                  label: 'Valor',
                  value: _formatCurrency(periodo.valorTotal),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProdutosMaisCompradosCard extends StatelessWidget {
  const _ProdutosMaisCompradosCard({required this.produtos});

  final List<RelatorioProdutoItemEntity> produtos;

  @override
  Widget build(BuildContext context) {
    return _ReportSectionCard(
      title: 'Produtos mais comprados',
      emptyMessage: 'Nenhum produto comprado no periodo.',
      children: produtos.map((produto) {
        return ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.shopping_basket_outlined),
          title: Text(produto.produtoNome),
          subtitle: Text('${produto.categoriaNome} · ${produto.totalRegistros} registro(s)'),
          trailing: Text(
            '${_formatNumber(produto.quantidadeTotal)} ${produto.unidadeMedida}',
          ),
        );
      }).toList(growable: false),
    );
  }
}

class _ConsumoPorCategoriaCard extends StatelessWidget {
  const _ConsumoPorCategoriaCard({required this.categorias});

  final List<RelatorioCategoriaItemEntity> categorias;

  @override
  Widget build(BuildContext context) {
    return _ReportSectionCard(
      title: 'Consumo por categoria',
      emptyMessage: 'Nenhuma categoria consumida no periodo.',
      children: categorias.map((categoria) {
        return ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.category_outlined),
          title: Text(categoria.categoriaNome),
          subtitle: Text(
            '${categoria.totalProdutos} produto(s) · ${categoria.totalRegistros} registro(s)',
          ),
          trailing: Text(_formatNumber(categoria.quantidadeTotal)),
        );
      }).toList(growable: false),
    );
  }
}

class _ReportSectionCard extends StatelessWidget {
  const _ReportSectionCard({
    required this.title,
    required this.emptyMessage,
    required this.children,
  });

  final String title;
  final String emptyMessage;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (children.isEmpty)
              Text(emptyMessage)
            else
              ...children,
          ],
        ),
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text('$label: $value'),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _EmptyRelatorioCard extends StatelessWidget {
  const _EmptyRelatorioCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text('Nenhuma compra registrada para o periodo selecionado.'),
      ),
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
                    'Nao foi possivel carregar os relatorios',
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

String _formatDate(DateTime? date) {
  if (date == null) {
    return 'sem limite';
  }

  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

String _formatNumber(double value) {
  if (value == value.roundToDouble()) {
    return value.toStringAsFixed(0);
  }

  return value.toStringAsFixed(2);
}

String _formatCurrency(double? value) {
  if (value == null) {
    return 'indisponivel';
  }

  return 'R\$ ${value.toStringAsFixed(2)}';
}
