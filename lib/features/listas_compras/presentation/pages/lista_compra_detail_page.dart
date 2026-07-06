import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../produtos/application/produto_providers.dart';
import '../../../produtos/domain/entities/produto_list_item_entity.dart';
import '../../application/lista_compra_providers.dart';
import '../../application/listas_compras_paginadas_provider.dart';
import '../../domain/entities/lista_compra_entity.dart';
import '../../domain/entities/lista_compra_form_data.dart';
import '../../domain/entities/lista_compra_item_entity.dart';
import '../../domain/entities/lista_compra_status.dart';

class ListaCompraDetailPage extends ConsumerWidget {
  const ListaCompraDetailPage({required this.listaId, super.key});

  final int listaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listaState = ref.watch(listaCompraPorIdProvider(listaId));

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhe da lista')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddItemSheet(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Item'),
      ),
      body: listaState.when(
        data: (lista) {
          if (lista == null) {
            return const Center(child: Text('Lista nao encontrada.'));
          }

          return _ListaDetail(lista: lista);
        },
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Nao foi possivel carregar a lista.\n$error',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<void> _showAddItemSheet(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _AddItemSheet(listaId: listaId),
    );
  }
}

class _ListaDetail extends ConsumerWidget {
  const _ListaDetail({required this.lista});

  final ListaCompraEntity lista;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(lista.nome, style: textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(_statusLabel()),
        const SizedBox(height: 16),
        if (lista.status == ListaCompraStatus.aberta)
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _concluirLista(context, ref),
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Concluir lista'),
            ),
          ),
        const SizedBox(height: 16),
        if (lista.itens.isEmpty)
          const Center(child: Text('Nenhum item adicionado.'))
        else
          ...lista.itens.map(
            (item) => _ListaItemTile(
              item: item,
              canEdit: lista.status == ListaCompraStatus.aberta,
            ),
          ),
      ],
    );
  }

  Future<void> _concluirLista(BuildContext context, WidgetRef ref) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Concluir lista'),
        content: const Text(
          'Deseja marcar esta lista como concluída e gerar um histórico de compra?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Concluir'),
          ),
        ],
      ),
    );

    if (confirmar != true) {
      return;
    }

    try {
      await ref.read(concluirListaCompraUseCaseProvider).call(lista.id);
      await ref.read(gerarHistoricoCompraListaUseCaseProvider).call(lista.id);
      ref.invalidate(listaCompraPorIdProvider(lista.id));
      ref.invalidate(listasComprasProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lista concluída e registrada no histórico.')),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao concluir lista: $error')),
        );
      }
    }
  }

  String _statusLabel() {
    return switch (lista.status) {
      ListaCompraStatus.aberta =>
        '${lista.totalComprados}/${lista.totalItens} comprado(s)',
      ListaCompraStatus.concluida => 'Lista concluida',
    };
  }
}

class _ListaItemTile extends ConsumerWidget {
  const _ListaItemTile({required this.item, required this.canEdit});

  final ListaCompraItemEntity item;
  final bool canEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: CheckboxListTile(
        value: item.isComprado,
        title: Text(item.produtoNome),
        subtitle: Text(_subtitle()),
        enabled: canEdit,
        onChanged: canEdit ? (value) => _marcarComprado(ref, value ?? false) : null,
      ),
    );
  }

  Future<void> _marcarComprado(WidgetRef ref, bool isComprado) async {
    await ref
        .read(marcarItemListaCompradoUseCaseProvider)
        .call(
          itemId: item.id,
          isComprado: isComprado,
          quantidadeComprada: isComprado ? item.quantidadePlanejada : 0,
        );

    ref.invalidate(listaCompraPorIdProvider(item.listaCompraId));
    ref.invalidate(listasComprasProvider);
    ref.read(listasComprasPaginadasProvider.notifier).resetar();
  }

  String _subtitle() {
    final planejada =
        '${_formatNumber(item.quantidadePlanejada)} ${item.unidadeMedida}';

    if (!item.isComprado) {
      return planejada;
    }

    return '$planejada - comprado ${_formatNumber(item.quantidadeComprada)}';
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(2);
  }
}

class _AddItemSheet extends ConsumerStatefulWidget {
  const _AddItemSheet({required this.listaId});

  final int listaId;

  @override
  ConsumerState<_AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends ConsumerState<_AddItemSheet> {
  final _formKey = GlobalKey<FormState>();
  final _quantidadeController = TextEditingController();
  final _observacoesController = TextEditingController();
  final _buscaController = TextEditingController();
  final _buscaFocusNode = FocusNode();
  int? _produtoId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_buscaFocusNode);
    });
  }

  @override
  void dispose() {
    _quantidadeController.dispose();
    _observacoesController.dispose();
    _buscaController.dispose();
    _buscaFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final produtosState = ref.watch(produtosListagemProvider);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomInset + 16),
      child: produtosState.when(
        data: (produtos) {
          final ativos = produtos
              .where((produto) => produto.isAtivo)
              .where(_filtrarPorBusca)
              .toList(growable: false);

          return _buildForm(ativos);
        },
        error: (error, stackTrace) => Text(
          'Nao foi possivel carregar produtos.\n$error',
          textAlign: TextAlign.center,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildForm(List<ProdutoListItemEntity> produtos) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _buscaController,
              focusNode: _buscaFocusNode,
              decoration: const InputDecoration(
                labelText: 'Buscar produto',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              textInputAction: TextInputAction.search,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            if (produtos.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Nenhum produto encontrado para a busca atual.',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              DropdownButtonFormField<int>(
              initialValue: _produtoId,
              decoration: const InputDecoration(
                labelText: 'Produto',
                border: OutlineInputBorder(),
              ),
              items: produtos
                  .map(
                    (produto) => DropdownMenuItem(
                      value: produto.id,
                      child: Text(produto.nome),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _produtoId = value),
              validator: (value) {
                if (value == null) {
                  return 'Selecione um produto.';
                }

                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _quantidadeController,
              decoration: const InputDecoration(
                labelText: 'Quantidade planejada',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
              ],
              validator: (value) {
                final quantidade = _parseDouble(value);

                if (quantidade == null || quantidade <= 0) {
                  return 'Informe uma quantidade maior que zero.';
                }

                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _observacoesController,
              decoration: const InputDecoration(
                labelText: 'Observacoes',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSaving ? null : _salvar,
                icon: _isSaving
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.add),
                label: const Text('Adicionar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      await ref
          .read(adicionarItemListaCompraUseCaseProvider)
          .call(
            ListaCompraItemFormData(
              listaCompraId: widget.listaId,
              produtoId: _produtoId!,
              quantidadePlanejada: _parseDouble(_quantidadeController.text)!,
              observacoes: _observacoesController.text,
            ),
          );

      ref.invalidate(listaCompraPorIdProvider(widget.listaId));
      ref.invalidate(listasComprasProvider);

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao adicionar: $error')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  bool _filtrarPorBusca(ProdutoListItemEntity produto) {
    final busca = _buscaController.text.trim().toLowerCase();

    if (busca.isEmpty) {
      return true;
    }

    return produto.nome.toLowerCase().contains(busca);
  }

  double? _parseDouble(String? value) {
    final normalized = value?.trim().replaceAll(',', '.');

    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    return double.tryParse(normalized);
  }
}
