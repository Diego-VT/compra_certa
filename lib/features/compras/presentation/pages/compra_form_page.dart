import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../produtos/application/produto_providers.dart';
import '../../../produtos/domain/entities/produto_entity.dart';
import '../../application/compra_providers.dart';
import '../../domain/entities/registrar_compra_data.dart';

class CompraFormPage extends ConsumerStatefulWidget {
  const CompraFormPage({super.key});

  @override
  ConsumerState<CompraFormPage> createState() => _CompraFormPageState();
}

class _CompraFormPageState extends ConsumerState<CompraFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _quantidadeController = TextEditingController();
  final _valorController = TextEditingController();
  final _observacoesController = TextEditingController();
  final _itens = <_CompraFormItem>[];

  int? _produtoId;
  int _produtoFieldVersion = 0;
  DateTime _dataCompra = DateTime.now();
  bool _isSaving = false;

  @override
  void dispose() {
    _quantidadeController.dispose();
    _valorController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final produtosState = ref.watch(produtosProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Nova compra')),
      body: produtosState.when(
        data: (produtos) {
          final produtosAtivos = produtos
              .where((produto) => produto.isAtivo)
              .toList(growable: false);

          return _buildForm(produtosAtivos);
        },
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Nao foi possivel carregar os produtos.\n$error',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildForm(List<ProdutoEntity> produtos) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.event_outlined),
            title: Text(_formatDate(_dataCompra)),
            trailing: IconButton(
              tooltip: 'Selecionar data',
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_month_outlined),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            key: ValueKey(_produtoFieldVersion),
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
              labelText: 'Quantidade',
              border: OutlineInputBorder(),
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
            controller: _valorController,
            decoration: const InputDecoration(
              labelText: 'Valor unitario opcional',
              border: OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
            ],
            validator: (value) {
              final normalized = value?.trim();

              if (normalized == null || normalized.isEmpty) {
                return null;
              }

              final valor = _parseDouble(value);

              if (valor == null || valor < 0) {
                return 'Informe um valor valido.';
              }

              return null;
            },
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: produtos.isEmpty
                  ? null
                  : () => _adicionarItem(produtos),
              icon: const Icon(Icons.add),
              label: const Text('Adicionar item'),
            ),
          ),
          const SizedBox(height: 16),
          if (_itens.isEmpty)
            const Center(child: Text('Nenhum item adicionado.'))
          else
            ..._itens.map(
              (item) => Card(
                child: ListTile(
                  title: Text(item.produtoNome),
                  subtitle: Text(item.description),
                  trailing: IconButton(
                    tooltip: 'Remover item',
                    onPressed: () => setState(() => _itens.remove(item)),
                    icon: const Icon(Icons.delete_outline),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _observacoesController,
            decoration: const InputDecoration(
              labelText: 'Observacoes',
              border: OutlineInputBorder(),
            ),
            minLines: 2,
            maxLines: 4,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _isSaving ? null : _salvarCompra,
            icon: _isSaving
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save_outlined),
            label: const Text('Salvar compra'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _dataCompra,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );

    if (selected == null) {
      return;
    }

    setState(() => _dataCompra = selected);
  }

  void _adicionarItem(List<ProdutoEntity> produtos) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final produto = produtos.firstWhere((produto) => produto.id == _produtoId);
    final quantidade = _parseDouble(_quantidadeController.text)!;
    final valorUnitario = _parseDouble(_valorController.text);
    final produtoJaAdicionado = _itens.any(
      (item) => item.produtoId == produto.id,
    );

    if (produtoJaAdicionado) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto ja adicionado na compra.')),
      );
      return;
    }

    setState(() {
      _itens.add(
        _CompraFormItem(
          produtoId: produto.id,
          produtoNome: produto.nome,
          unidadeMedida: produto.unidadeMedida,
          quantidade: quantidade,
          valorUnitario: valorUnitario,
        ),
      );
      _produtoId = null;
      _produtoFieldVersion++;
      _quantidadeController.clear();
      _valorController.clear();
    });
  }

  Future<void> _salvarCompra() async {
    if (_itens.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adicione ao menos um item.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await ref
          .read(registrarCompraUseCaseProvider)
          .call(
            RegistrarCompraData(
              dataCompra: _dataCompra,
              observacoes: _observacoesController.text,
              itens: _itens
                  .map(
                    (item) => RegistrarCompraItemData(
                      produtoId: item.produtoId,
                      quantidade: item.quantidade,
                      valorUnitario: item.valorUnitario,
                    ),
                  )
                  .toList(growable: false),
            ),
          );

      ref.invalidate(comprasProvider);

      if (mounted) {
        context.goNamed(AppRoute.compras.name);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao salvar: $error')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  double? _parseDouble(String? value) {
    final normalized = value?.trim().replaceAll(',', '.');

    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    return double.tryParse(normalized);
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

}

class _CompraFormItem {
  const _CompraFormItem({
    required this.produtoId,
    required this.produtoNome,
    required this.unidadeMedida,
    required this.quantidade,
    this.valorUnitario,
  });

  final int produtoId;
  final String produtoNome;
  final String unidadeMedida;
  final double quantidade;
  final double? valorUnitario;

  double? get valorTotal {
    final valor = valorUnitario;

    if (valor == null) {
      return null;
    }

    return valor * quantidade;
  }

  String get description {
    final base = '${_formatNumber(quantidade)} $unidadeMedida';
    final valor = valorUnitario;
    final total = valorTotal;

    if (valor == null || total == null) {
      return base;
    }

    return '$base - R\$ ${valor.toStringAsFixed(2)} un. - Total R\$ ${total.toStringAsFixed(2)}';
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(2);
  }
}
