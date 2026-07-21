import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_bottom_navigation.dart';
import '../../../compras/domain/entities/compra_list_item_entity.dart';
import '../../../estoque/domain/entities/estoque_entity.dart';
import '../../../listas_compras/application/lista_compra_providers.dart';
import '../../../listas_compras/application/listas_compras_paginadas_provider.dart';
import '../../../listas_compras/domain/entities/lista_compra_list_item_entity.dart';
import '../../application/dashboard_providers.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  bool _isGeneratingList = false;

  @override
  Widget build(BuildContext context) {
    final resumoState = ref.watch(dashboardResumoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Início'),
        actions: [
          IconButton(
            tooltip: 'Notificações',
            onPressed: () =>
                context.goNamed(AppRoute.preferenciasNotificacao.name),
            icon: const Icon(Icons.notifications_outlined),
          ),
          IconButton(
            tooltip: 'Sugestões',
            onPressed: () =>
                context.goNamed(AppRoute.sugestoesInteligentes.name),
            icon: const Icon(Icons.auto_awesome_outlined),
          ),
          IconButton(
            tooltip: 'Relatórios',
            onPressed: () => context.goNamed(AppRoute.relatorios.name),
            icon: const Icon(Icons.analytics_outlined),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavigation(
        currentDestination: AppMainDestination.dashboard,
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(dashboardResumoProvider),
        child: resumoState.when(
          data: (resumo) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _DashboardHeader(
                onNovaLista: () =>
                    context.goNamed(AppRoute.novaListaCompra.name),
              ),
              const SizedBox(height: 20),
              _DashboardSectionCard(
                title: 'Itens acabando na despensa',
                value: resumo.produtosAbaixoMinimo.length.toString(),
                subtitle: 'Itens que precisam de reposição urgente',
                icon: Icons.warning_amber_rounded,
                onTap: () => context.goNamed(AppRoute.estoque.name),
                details: _buildProdutosDetails(
                  context,
                  resumo.produtosAbaixoMinimo,
                ),
                action: resumo.produtosAbaixoMinimo.isEmpty
                    ? null
                    : FilledButton.icon(
                        onPressed: _isGeneratingList
                            ? null
                            : () => _gerarListaPorEstoqueBaixo(
                                resumo.produtosAbaixoMinimo.length,
                              ),
                        icon: _isGeneratingList
                            ? const SizedBox.square(
                                dimension: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.shopping_cart_checkout),
                        label: Text(
                          'Gerar lista com ${_itemCountLabel(resumo.produtosAbaixoMinimo.length)}',
                        ),
                      ),
              ),
              const SizedBox(height: 12),
              _DashboardSectionCard(
                title: 'Listas abertas',
                value: resumo.listasAbertas.length.toString(),
                subtitle: 'Listas de compras em andamento',
                icon: Icons.list_alt_outlined,
                onTap: () => context.goNamed(AppRoute.listasCompras.name),
                details: _buildListasDetails(context, resumo.listasAbertas),
              ),
              const SizedBox(height: 12),
              _DashboardSectionCard(
                title: 'Compras recentes',
                value: resumo.comprasRecentes.length.toString(),
                subtitle: 'Últimas compras registradas',
                icon: Icons.receipt_long_outlined,
                onTap: () => context.goNamed(AppRoute.compras.name),
                details: _buildComprasDetails(context, resumo.comprasRecentes),
              ),
            ],
          ),
          error: (error, stackTrace) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _ErrorStateCard(
                message: 'Não foi possível carregar o início',
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

  List<Widget> _buildProdutosDetails(
    BuildContext context,
    List<EstoqueEntity> produtos,
  ) {
    if (produtos.isEmpty) {
      return const [
        _EmptyState(message: 'Nenhum produto precisa de reposição agora.'),
      ];
    }

    return produtos.take(3).map((produto) {
      final estaZerado = produto.quantidadeAtual == 0;
      return ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          estaZerado ? Icons.error_outline : Icons.inventory_2_outlined,
          size: 20,
          color: estaZerado ? Theme.of(context).colorScheme.error : null,
        ),
        title: Text(produto.produtoNome),
        subtitle: Text(
          '${_formatNumber(produto.quantidadeAtual)} ${produto.unidadeMedida} em estoque · mínimo ${_formatNumber(produto.quantidadeMinima)}',
          style: estaZerado
              ? TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w600,
                )
              : null,
        ),
      );
    }).toList();
  }

  List<Widget> _buildListasDetails(
    BuildContext context,
    List<ListaCompraListItemEntity> listas,
  ) {
    if (listas.isEmpty) {
      return [
        _EmptyState(
          message: 'Não há listas abertas no momento.',
          action: OutlinedButton.icon(
            onPressed: () => context.goNamed(AppRoute.novaListaCompra.name),
            icon: const Icon(Icons.add),
            label: const Text('Criar primeira lista'),
          ),
        ),
      ];
    }

    return listas.take(3).map((lista) {
      return ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.list_alt_outlined, size: 20),
        title: Text(lista.nome),
        subtitle: Text(
          '${lista.totalItens} itens · ${lista.totalComprados} comprados',
        ),
      );
    }).toList();
  }

  List<Widget> _buildComprasDetails(
    BuildContext context,
    List<CompraListItemEntity> compras,
  ) {
    if (compras.isEmpty) {
      return const [_EmptyState(message: 'Nenhuma compra recente registrada.')];
    }

    return compras.take(3).map((compra) {
      return ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.receipt_long_outlined, size: 20),
        title: Text('Compra realizada em ${_formatDate(compra.dataCompra)}'),
        subtitle: Text('${compra.totalItens} itens registrados'),
        trailing: IconButton(
          tooltip: 'Ver detalhes',
          onPressed: () => context.goNamed(
            AppRoute.detalheCompra.name,
            pathParameters: {'id': compra.id.toString()},
          ),
          icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
        ),
      );
    }).toList();
  }

  Future<void> _gerarListaPorEstoqueBaixo(int quantidade) async {
    if (_isGeneratingList) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Gerar lista de reposição'),
        content: Text(
          'Criar uma lista com ${_itemCountLabel(quantidade)} que ${quantidade == 1 ? 'está acabando' : 'estão acabando'}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Gerar lista'),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    setState(() => _isGeneratingList = true);

    try {
      final id = await ref
          .read(gerarListaPorEstoqueBaixoUseCaseProvider)
          .call('Reposição da despensa');
      ref.invalidate(listasComprasProvider);
      ref.invalidate(listasComprasPaginadasProvider);
      ref.invalidate(dashboardResumoProvider);

      if (mounted) {
        context.goNamed(
          AppRoute.detalheListaCompra.name,
          pathParameters: {'id': id.toString()},
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível gerar a lista: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _isGeneratingList = false);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatNumber(double value) {
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(2);
  }

  String _itemCountLabel(int count) =>
      '$count ${count == 1 ? 'item' : 'itens'}';
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({required this.onNovaLista});

  final VoidCallback onNovaLista;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final title = Text(
          'Olá! Veja o status da sua despensa hoje.',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        );
        final button = FilledButton.icon(
          onPressed: onNovaLista,
          icon: const Icon(Icons.add),
          label: const Text('Nova lista'),
        );

        final largeText = MediaQuery.textScalerOf(context).scale(16) > 20;
        if (constraints.maxWidth < 420 || largeText) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              const SizedBox(height: 12),
              SizedBox(width: double.infinity, child: button),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: title),
            const SizedBox(width: 12),
            button,
          ],
        );
      },
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
    this.action,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final List<Widget> details;
  final VoidCallback? onTap;
  final Widget? action;

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
            if (action != null) ...[
              const SizedBox(height: 12),
              SizedBox(width: double.infinity, child: action),
            ],
            if (onTap != null) ...[
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Ver todos'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message, this.action});

  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        if (action != null) ...[const SizedBox(height: 12), action!],
      ],
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
                Expanded(
                  child: Text(
                    message,
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
