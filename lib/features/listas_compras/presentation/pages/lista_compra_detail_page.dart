import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../produtos/application/produto_providers.dart';
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
      floatingActionButton: listaState.maybeWhen(
        data: (lista) {
          if (lista?.status != ListaCompraStatus.aberta) {
            return null;
          }

          return FloatingActionButton.extended(
            onPressed: () => _showAddItemSheet(context),
            icon: const Icon(Icons.add),
            label: const Text('Item'),
          );
        },
        orElse: () => null,
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

  Future<void> _showAddItemSheet(BuildContext context) async {
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
          const SnackBar(
            content: Text('Lista concluída e registrada no histórico.'),
          ),
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
        onChanged: canEdit
            ? (value) => _marcarComprado(ref, value ?? false)
            : null,
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
  static const _produtosPorPagina = 20;

  final _formKey = GlobalKey<FormState>();
  final _quantidadeController = TextEditingController(text: '1');
  final _observacoesController = TextEditingController();
  final _buscaController = TextEditingController();
  final _buscaFocusNode = FocusNode();
  int? _produtoId;
  String? _produtoErro;
  int _produtosVisiveis = _produtosPorPagina;
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
    final busca = _buscaController.text;
    final produtosState = ref.watch(produtosAtivosBuscaProvider(busca));
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, bottomInset + 16),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.82,
          child: produtosState.when(
            skipLoadingOnReload: true,
            data: (produtos) {
              final opcoes = produtos
                  .map(
                    (produto) => _ProdutoOpcao(
                      id: produto.id,
                      nome: produto.nome,
                      unidadeMedida: produto.unidadeMedida,
                      marca: produto.marca,
                      observacoes: produto.observacoes,
                    ),
                  )
                  .toList(growable: false);

              return _buildForm(opcoes);
            },
            error: (error, stackTrace) => Text(
              'Nao foi possivel carregar produtos.\n$error',
              textAlign: TextAlign.center,
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(List<_ProdutoOpcao> produtos) {
    final busca = _buscaController.text.trim();
    final produtosPagina = produtos.take(_produtosVisiveis).toList(growable: false);
    final hasMore = produtos.length > produtosPagina.length;
    final produtoSelecionado = _produtoSelecionado(produtos);
    final emptyMessage = busca.isEmpty
        ? 'Nenhum produto ativo disponivel. Cadastre ou reative um produto antes de adicionar itens.'
        : 'Nenhum produto ativo encontrado para "$busca".';

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Adicionar item',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 12),
          RawAutocomplete<_ProdutoOpcao>(
            textEditingController: _buscaController,
            focusNode: _buscaFocusNode,
            optionsBuilder: (textEditingValue) {
              return produtos;
            },
            displayStringForOption: (produto) => produto.nome,
            fieldViewBuilder: (
              context,
              controller,
              focusNode,
              onFieldSubmitted,
            ) {
              return TextFormField(
                controller: controller,
                focusNode: focusNode,
                decoration: const InputDecoration(
                  labelText: 'Buscar produto',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                textInputAction: TextInputAction.search,
                onChanged: (_) {
                  setState(() {
                    _produtoId = null;
                    _produtoErro = null;
                    _produtosVisiveis = _produtosPorPagina;
                  });
                },
              );
            },
            optionsViewBuilder: (
              context,
              onSelected,
              options,
            ) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(12),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 240),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options.elementAt(index);

                        return ListTile(
                          title: Text(option.nome),
                          subtitle: Text(
                            [
                              option.marca ?? '',
                              option.unidadeMedida,
                              option.observacoes ?? '',
                            ]
                                .where((value) => value.isNotEmpty)
                                .join(' • '),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () => onSelected(option),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
            onSelected: (produto) {
              setState(() {
                _produtoId = produto.id;
                _produtoErro = null;
                _buscaController.text = produto.nome;
              });
            },
          ),
          const SizedBox(height: 12),
          if (_produtoErro != null) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _produtoErro!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
            const SizedBox(height: 8),
          ],
          Expanded(
            child: _ProdutosPaginadosList(
              produtos: produtosPagina,
              totalProdutos: produtos.length,
              hasMore: hasMore,
              produtoId: _produtoId,
              emptyMessage: emptyMessage,
              onProdutoSelected: (produto) {
                setState(() {
                  _produtoId = produto.id;
                  _produtoErro = null;
                  _buscaController.text = produto.nome;
                });
              },
              onLoadMore: _carregarMaisProdutos,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _quantidadeController,
            decoration: InputDecoration(
              labelText: produtoSelecionado == null
                  ? 'Quantidade planejada'
                  : 'Quantidade planejada (${produtoSelecionado.unidadeMedida})',
              border: const OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
    );
  }

  Future<void> _salvar() async {
    final form = _formKey.currentState;
    final produtoId = _produtoId;
    final quantidade = _parseDouble(_quantidadeController.text);

    if (produtoId == null) {
      setState(() => _produtoErro = 'Selecione um produto.');
    }

    if (form == null || !form.validate() || produtoId == null) {
      return;
    }

    if (quantidade == null || quantidade <= 0) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      await ref
          .read(adicionarItemListaCompraUseCaseProvider)
          .call(
            ListaCompraItemFormData(
              listaCompraId: widget.listaId,
              produtoId: produtoId,
              quantidadePlanejada: quantidade,
              observacoes: _observacoesController.text,
            ),
          );

      ref.invalidate(listaCompraPorIdProvider(widget.listaId));
      ref.invalidate(listasComprasProvider);
      ref.read(listasComprasPaginadasProvider.notifier).resetar();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item adicionado a lista.')),
        );
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

  _ProdutoOpcao? _produtoSelecionado(List<_ProdutoOpcao> produtos) {
    for (final produto in produtos) {
      if (produto.id == _produtoId) {
        return produto;
      }
    }

    return null;
  }

  double? _parseDouble(String? value) {
    final normalized = value?.trim().replaceAll(',', '.');

    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    return double.tryParse(normalized);
  }

  void _carregarMaisProdutos() {
    setState(() {
      _produtosVisiveis += _produtosPorPagina;
    });
  }
}

class _ProdutosPaginadosList extends StatelessWidget {
  const _ProdutosPaginadosList({
    required this.produtos,
    required this.totalProdutos,
    required this.hasMore,
    required this.produtoId,
    required this.emptyMessage,
    required this.onProdutoSelected,
    required this.onLoadMore,
  });

  final List<_ProdutoOpcao> produtos;
  final int totalProdutos;
  final bool hasMore;
  final int? produtoId;
  final String emptyMessage;
  final ValueChanged<_ProdutoOpcao> onProdutoSelected;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    if (produtos.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Produtos (${produtos.length}/$totalProdutos)',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.separated(
            itemCount: produtos.length + (hasMore ? 1 : 0),
            separatorBuilder: (context, index) => const SizedBox(height: 6),
            itemBuilder: (context, index) {
              if (index == produtos.length) {
                return OutlinedButton.icon(
                  onPressed: onLoadMore,
                  icon: const Icon(Icons.expand_more),
                  label: const Text('Carregar mais produtos'),
                );
              }

              final produto = produtos[index];
              final isSelected = produto.id == produtoId;

              return _ProdutoOpcaoTile(
                produto: produto,
                isSelected: isSelected,
                onTap: () => onProdutoSelected(produto),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ProdutoOpcaoTile extends StatelessWidget {
  const _ProdutoOpcaoTile({
    required this.produto,
    required this.isSelected,
    required this.onTap,
  });

  final _ProdutoOpcao produto;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
        ),
      ),
      leading: Icon(
        isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
        color: isSelected ? colorScheme.primary : null,
      ),
      title: Text(produto.nome, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text('Unidade: ${produto.unidadeMedida}'),
      selected: isSelected,
      onTap: onTap,
    );
  }
}

class _ProdutoOpcao {
  const _ProdutoOpcao({
    required this.id,
    required this.nome,
    required this.unidadeMedida,
    this.marca,
    this.observacoes,
  });

  final int id;
  final String nome;
  final String unidadeMedida;
  final String? marca;
  final String? observacoes;
}
