import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../application/produto_providers.dart';
import '../../domain/entities/produto_entity.dart';

class ProdutosPage extends ConsumerWidget {
  const ProdutosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final produtosState = ref.watch(produtosProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Produtos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.goNamed(AppRoute.novoProduto.name),
        icon: const Icon(Icons.add),
        label: const Text('Novo'),
      ),
      body: produtosState.when(
        data: (produtos) => _ProdutosList(produtos: produtos),
        error: (error, stackTrace) => _ProdutosError(error: error),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _ProdutosList extends StatelessWidget {
  const _ProdutosList({required this.produtos});

  final List<ProdutoEntity> produtos;

  @override
  Widget build(BuildContext context) {
    if (produtos.isEmpty) {
      return const Center(child: Text('Nenhum produto cadastrado.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: produtos.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final produto = produtos[index];

        return Card(
          child: ListTile(
            title: Text(produto.nome),
            subtitle: Text(
              [
                produto.unidadeMedida,
                if (produto.marca != null) produto.marca!,
                'min. ${produto.quantidadeMinima}',
                'ideal ${produto.quantidadeIdeal}',
              ].join(' • '),
            ),
            trailing: produto.isAtivo
                ? const Icon(Icons.check_circle_outline)
                : const Icon(Icons.pause_circle_outline),
            onTap: () => context.goNamed(
              AppRoute.editarProduto.name,
              pathParameters: {'id': produto.id.toString()},
            ),
          ),
        );
      },
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
