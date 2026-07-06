import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../estoque/application/estoque_providers.dart';
import '../../application/lista_compra_providers.dart';
import '../../application/listas_compras_paginadas_provider.dart';
import '../../domain/entities/lista_compra_filtro.dart';
import '../../domain/entities/lista_compra_list_item_entity.dart';
import '../../domain/entities/lista_compra_status.dart';

class ListasComprasPage extends ConsumerWidget {
  const ListasComprasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtro = ref.watch(listaCompraFiltroProvider);
    final listasState = ref.watch(listasComprasPaginadasProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listas de compras'),
        actions: [
          IconButton(
            tooltip: 'Produtos',
            onPressed: () => context.goNamed(AppRoute.produtos.name),
            icon: const Icon(Icons.inventory_2_outlined),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'gerar-lista-estoque-baixo',
            tooltip: 'Gerar por estoque baixo',
            onPressed: () => _gerarPorEstoqueBaixo(context, ref),
            child: const Icon(Icons.auto_awesome_motion_outlined),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'nova-lista-compra',
            onPressed: () => context.goNamed(AppRoute.novaListaCompra.name),
            icon: const Icon(Icons.add),
            label: const Text('Lista'),
          ),
        ],
      ),
      body: listasState.when(
        data: (listas) => Column(
          children: [
            _ListasFilterBar(filtro: filtro),
            Expanded(
              child: _ListasList(
                listas: listas,
                hasMore: listas.length == filtro.limit,
              ),
            ),
          ],
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Nao foi possivel carregar as listas.\n$error',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<void> _gerarPorEstoqueBaixo(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final produtosAbaixo = await ref.read(produtosAbaixoMinimoProvider.future);

    if (!context.mounted) {
      return;
    }

    if (produtosAbaixo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhum produto abaixo do minimo.')),
      );
      return;
    }

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gerar lista'),
        content: Text(
          'Criar uma lista com ${produtosAbaixo.length} produto(s) abaixo do minimo?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Gerar'),
          ),
        ],
      ),
    );

    if (confirmar != true || !context.mounted) {
      return;
    }

    try {
      final id = await ref
          .read(gerarListaPorEstoqueBaixoUseCaseProvider)
          .call('Reposicao de estoque');

      ref.invalidate(listasComprasProvider);
      ref.read(listasComprasPaginadasProvider.notifier).resetar();

      if (context.mounted) {
        context.goNamed(
          AppRoute.detalheListaCompra.name,
          pathParameters: {'id': id.toString()},
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao gerar lista: $error')));
      }
    }
  }
}

class _ListasFilterBar extends ConsumerWidget {
  const _ListasFilterBar({required this.filtro});

  final ListaCompraFiltro filtro;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = filtro.status;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: SegmentedButton<ListaCompraStatus?>(
        segments: const [
          ButtonSegment(
            value: ListaCompraStatus.aberta,
            icon: Icon(Icons.shopping_cart_outlined),
            label: Text('Abertas'),
          ),
          ButtonSegment(
            value: ListaCompraStatus.concluida,
            icon: Icon(Icons.check_circle_outline),
            label: Text('Concluidas'),
          ),
          ButtonSegment(
            value: null,
            icon: Icon(Icons.list_alt_outlined),
            label: Text('Todas'),
          ),
        ],
        selected: {selected},
        onSelectionChanged: (selection) {
          final novoFiltro = filtro.copyWith(
            status: selection.single,
            limparStatus: selection.single == null,
            limit: 30,
            offset: 0,
          );
          ref.read(listaCompraFiltroProvider.notifier).state = novoFiltro;
          ref.read(listasComprasPaginadasProvider.notifier).resetar();
        },
      ),
    );
  }
}

class _ListasList extends ConsumerWidget {
  const _ListasList({required this.listas, required this.hasMore});

  final List<ListaCompraListItemEntity> listas;
  final bool hasMore;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (listas.isEmpty) {
      return const Center(child: Text('Nenhuma lista encontrada.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: listas.length + (hasMore ? 1 : 0),
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        if (index == listas.length) {
          return Center(
            child: OutlinedButton.icon(
              onPressed: () {
                ref.read(listasComprasPaginadasProvider.notifier).carregarMais();
              },
              icon: const Icon(Icons.expand_more),
              label: const Text('Carregar mais'),
            ),
          );
        }

        return _ListaCard(lista: listas[index]);
      },
    );
  }
}

class _ListaCard extends StatelessWidget {
  const _ListaCard({required this.lista});

  final ListaCompraListItemEntity lista;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: ListTile(
        leading: Icon(_statusIcon()),
        title: Text(lista.nome, style: textTheme.titleMedium),
        subtitle: Text(
          '${lista.totalComprados}/${lista.totalItens} comprado(s)',
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.goNamed(
          AppRoute.detalheListaCompra.name,
          pathParameters: {'id': lista.id.toString()},
        ),
      ),
    );
  }

  IconData _statusIcon() {
    return switch (lista.status) {
      ListaCompraStatus.aberta => Icons.shopping_cart_outlined,
      ListaCompraStatus.concluida => Icons.check_circle_outline,
    };
  }
}
