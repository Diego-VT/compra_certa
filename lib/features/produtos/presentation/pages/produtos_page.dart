import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../categorias/application/categoria_providers.dart';
import '../../../categorias/domain/entities/categoria_entity.dart';
import '../../application/produto_providers.dart';
import '../../domain/entities/produto_filtro.dart';
import '../../domain/entities/produto_list_item_entity.dart';

class ProdutosPage extends ConsumerStatefulWidget {
  const ProdutosPage({super.key});

  @override
  ConsumerState<ProdutosPage> createState() => _ProdutosPageState();
}

class _ProdutosPageState extends ConsumerState<ProdutosPage> {
  late final TextEditingController _buscaController;

  @override
  void initState() {
    super.initState();
    _buscaController = TextEditingController(
      text: ref.read(produtoFiltroProvider).busca,
    );
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtro = ref.watch(produtoFiltroProvider);
    final produtosState = ref.watch(produtosListagemProvider);
    final categoriasState = ref.watch(categoriasProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        actions: [
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.goNamed(AppRoute.novoProduto.name),
        icon: const Icon(Icons.add),
        label: const Text('Novo'),
      ),
      body: Column(
        children: [
          _ProdutosFilters(
            buscaController: _buscaController,
            filtro: filtro,
            categoriasState: categoriasState,
            onBuscaChanged: _atualizarBusca,
            onCategoriaChanged: _atualizarCategoria,
            onStatusChanged: _atualizarStatus,
          ),
          Expanded(
            child: produtosState.when(
              data: (produtos) => _ProdutosList(produtos: produtos),
              error: (error, stackTrace) => _ProdutosError(error: error),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }

  void _atualizarBusca(String busca) {
    ref.read(produtoFiltroProvider.notifier).state = ref
        .read(produtoFiltroProvider)
        .copyWith(busca: busca);
  }

  void _atualizarCategoria(int? categoriaId) {
    ref.read(produtoFiltroProvider.notifier).state = ref
        .read(produtoFiltroProvider)
        .copyWith(
          categoriaId: categoriaId,
          limparCategoria: categoriaId == null,
        );
  }

  void _atualizarStatus(ProdutoStatusFiltro status) {
    ref.read(produtoFiltroProvider.notifier).state = ref
        .read(produtoFiltroProvider)
        .copyWith(status: status);
  }
}

class _ProdutosFilters extends StatelessWidget {
  const _ProdutosFilters({
    required this.buscaController,
    required this.filtro,
    required this.categoriasState,
    required this.onBuscaChanged,
    required this.onCategoriaChanged,
    required this.onStatusChanged,
  });

  final TextEditingController buscaController;
  final ProdutoFiltro filtro;
  final AsyncValue<List<CategoriaEntity>> categoriasState;
  final ValueChanged<String> onBuscaChanged;
  final ValueChanged<int?> onCategoriaChanged;
  final ValueChanged<ProdutoStatusFiltro> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Column(
          children: [
            TextField(
              controller: buscaController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                labelText: 'Buscar por nome',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: filtro.busca.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Limpar busca',
                        onPressed: () {
                          buscaController.clear();
                          onBuscaChanged('');
                        },
                        icon: const Icon(Icons.close),
                      ),
              ),
              onChanged: onBuscaChanged,
            ),
            const SizedBox(height: 12),
            categoriasState.when(
              data: (categorias) => DropdownButtonFormField<int?>(
                initialValue: filtro.categoriaId,
                decoration: const InputDecoration(labelText: 'Categoria'),
                items: [
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text('Todas as categorias'),
                  ),
                  ...categorias.map(
                    (categoria) => DropdownMenuItem<int?>(
                      value: categoria.id,
                      child: Text(
                        categoria.caminhoCompleto,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
                onChanged: onCategoriaChanged,
              ),
              error: (error, stackTrace) => Align(
                alignment: Alignment.centerLeft,
                child: Text('Categorias indisponiveis: $error'),
              ),
              loading: () => const LinearProgressIndicator(),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: SegmentedButton<ProdutoStatusFiltro>(
                segments: const [
                  ButtonSegment(
                    value: ProdutoStatusFiltro.ativos,
                    icon: Icon(Icons.check_circle_outline),
                    label: Text('Ativos'),
                  ),
                  ButtonSegment(
                    value: ProdutoStatusFiltro.inativos,
                    icon: Icon(Icons.pause_circle_outline),
                    label: Text('Inativos'),
                  ),
                  ButtonSegment(
                    value: ProdutoStatusFiltro.todos,
                    icon: Icon(Icons.list_alt_outlined),
                    label: Text('Todos'),
                  ),
                ],
                selected: {filtro.status},
                onSelectionChanged: (selection) {
                  onStatusChanged(selection.single);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProdutosList extends ConsumerWidget {
  const _ProdutosList({required this.produtos});

  final List<ProdutoListItemEntity> produtos;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (produtos.isEmpty) {
      return const Center(child: Text('Nenhum produto encontrado.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: produtos.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final produto = produtos[index];

        return _ProdutoCard(
          produto: produto,
          onTap: () => context.goNamed(
            AppRoute.editarProduto.name,
            pathParameters: {'id': produto.id.toString()},
          ),
          onToggleStatus: () => _alterarStatus(ref, produto),
        );
      },
    );
  }

  Future<void> _alterarStatus(
    WidgetRef ref,
    ProdutoListItemEntity produto,
  ) async {
    await ref
        .read(alterarStatusProdutoUseCaseProvider)
        .call(id: produto.id, isAtivo: !produto.isAtivo);
    ref.invalidate(produtosListagemProvider);
    ref.invalidate(produtosProvider);
    ref.invalidate(produtoPorIdProvider(produto.id));
  }
}

class _ProdutoCard extends StatelessWidget {
  const _ProdutoCard({
    required this.produto,
    required this.onTap,
    required this.onToggleStatus,
  });

  final ProdutoListItemEntity produto;
  final VoidCallback onTap;
  final VoidCallback onToggleStatus;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final statusColor = produto.isAtivo
        ? colorScheme.primary
        : colorScheme.error;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
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
                        Text(produto.nome, style: textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text(
                          produto.categoriaCaminho,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: produto.isAtivo ? 'Desativar' : 'Reativar',
                    onPressed: onToggleStatus,
                    icon: Icon(
                      produto.isAtivo
                          ? Icons.toggle_on_outlined
                          : Icons.toggle_off_outlined,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _InfoChip(
                    icon: Icons.straighten,
                    label: 'Unidade: ${produto.unidadeMedida}',
                  ),
                  _InfoChip(
                    icon: Icons.remove_circle_outline,
                    label: 'Minima: ${_formatNumber(produto.quantidadeMinima)}',
                  ),
                  _InfoChip(
                    icon: Icons.add_circle_outline,
                    label: 'Ideal: ${_formatNumber(produto.quantidadeIdeal)}',
                  ),
                  _InfoChip(
                    icon: produto.isAtivo
                        ? Icons.check_circle_outline
                        : Icons.pause_circle_outline,
                    label: produto.isAtivo ? 'Ativo' : 'Inativo',
                    color: statusColor,
                  ),
                  const _InfoChip(
                    icon: Icons.inventory_2_outlined,
                    label: 'Estoque: futuro',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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

class _ProdutosError extends StatelessWidget {
  const _ProdutosError({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Nao foi possivel carregar os produtos.\n$error',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
