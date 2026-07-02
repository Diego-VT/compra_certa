import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/categoria_providers.dart';
import '../../domain/entities/categoria_entity.dart';

class CategoriasPage extends ConsumerWidget {
  const CategoriasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriasState = ref.watch(categoriasProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Categorias')),
      body: categoriasState.when(
        data: (categorias) => _CategoriasList(categorias: categorias),
        error: (error, stackTrace) => _CategoriasError(error: error),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _CategoriasList extends StatelessWidget {
  const _CategoriasList({required this.categorias});

  final List<CategoriaEntity> categorias;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (categorias.isEmpty) {
      return const Center(child: Text('Nenhuma categoria encontrada.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: categorias.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final categoria = categorias[index];
        final indent = ((categoria.nivel - 1).clamp(0, 6) * 12).toDouble();

        return Padding(
          padding: EdgeInsets.only(left: indent),
          child: Card(
            child: ListTile(
              dense: true,
              title: Text(categoria.nome),
              subtitle: Text(
                categoria.caminhoCompleto,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                'N${categoria.nivel}',
                style: textTheme.labelMedium,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CategoriasError extends StatelessWidget {
  const _CategoriasError({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Nao foi possivel carregar as categorias.\n$error',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
