import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../categorias/application/categoria_providers.dart';
import '../../../categorias/domain/entities/categoria_entity.dart';
import '../../application/produto_providers.dart';
import '../../domain/entities/produto_entity.dart';
import '../../domain/entities/produto_form_data.dart';

class ProdutoFormPage extends ConsumerStatefulWidget {
  const ProdutoFormPage({super.key, this.produtoId});

  final int? produtoId;

  @override
  ConsumerState<ProdutoFormPage> createState() => _ProdutoFormPageState();
}

class _ProdutoFormPageState extends ConsumerState<ProdutoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _unidadeMedidaController = TextEditingController(text: 'un');
  final _marcaController = TextEditingController();
  final _quantidadeMinimaController = TextEditingController(text: '0');
  final _quantidadeIdealController = TextEditingController(text: '0');
  final _observacoesController = TextEditingController();

  int? _categoriaId;
  bool _isAtivo = true;
  bool _isSaving = false;
  bool _produtoAplicado = false;

  bool get _isEditing => widget.produtoId != null;

  @override
  void dispose() {
    _nomeController.dispose();
    _unidadeMedidaController.dispose();
    _marcaController.dispose();
    _quantidadeMinimaController.dispose();
    _quantidadeIdealController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriasState = ref.watch(categoriasProvider);
    final produtoState = _isEditing
        ? ref.watch(produtoPorIdProvider(widget.produtoId!))
        : const AsyncData<ProdutoEntity?>(null);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar produto' : 'Novo produto'),
      ),
      body: categoriasState.when(
        data: (categorias) => produtoState.when(
          data: (produto) {
            _aplicarProduto(produto);

            return _ProdutoFormBody(
              formKey: _formKey,
              categorias: categorias,
              nomeController: _nomeController,
              unidadeMedidaController: _unidadeMedidaController,
              marcaController: _marcaController,
              quantidadeMinimaController: _quantidadeMinimaController,
              quantidadeIdealController: _quantidadeIdealController,
              observacoesController: _observacoesController,
              categoriaId: _categoriaId,
              isAtivo: _isAtivo,
              isSaving: _isSaving,
              onCategoriaChanged: (value) {
                setState(() => _categoriaId = value);
              },
              onIsAtivoChanged: (value) {
                setState(() => _isAtivo = value);
              },
              onSubmit: _salvarProduto,
            );
          },
          error: (error, stackTrace) => _FormError(error: error),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
        error: (error, stackTrace) => _FormError(error: error),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  void _aplicarProduto(ProdutoEntity? produto) {
    if (_produtoAplicado || produto == null) {
      return;
    }

    _produtoAplicado = true;
    _nomeController.text = produto.nome;
    _unidadeMedidaController.text = produto.unidadeMedida;
    _marcaController.text = produto.marca ?? '';
    _quantidadeMinimaController.text = produto.quantidadeMinima.toString();
    _quantidadeIdealController.text = produto.quantidadeIdeal.toString();
    _observacoesController.text = produto.observacoes ?? '';
    _categoriaId = produto.categoriaId;
    _isAtivo = produto.isAtivo;
  }

  Future<void> _salvarProduto() async {
    final form = _formKey.currentState;

    if (form == null || !form.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    final produto = ProdutoFormData(
      id: widget.produtoId,
      nome: _nomeController.text,
      categoriaId: _categoriaId!,
      unidadeMedida: _unidadeMedidaController.text,
      marca: _marcaController.text,
      quantidadeMinima: _parseDecimal(_quantidadeMinimaController.text),
      quantidadeIdeal: _parseDecimal(_quantidadeIdealController.text),
      observacoes: _observacoesController.text,
      isAtivo: _isAtivo,
    );

    try {
      await ref.read(salvarProdutoUseCaseProvider).call(produto);
      ref.invalidate(produtosProvider);

      if (mounted) {
        context.goNamed(AppRoute.produtos.name);
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  double _parseDecimal(String value) {
    return double.parse(value.replaceAll(',', '.'));
  }
}

class _ProdutoFormBody extends StatelessWidget {
  const _ProdutoFormBody({
    required this.formKey,
    required this.categorias,
    required this.nomeController,
    required this.unidadeMedidaController,
    required this.marcaController,
    required this.quantidadeMinimaController,
    required this.quantidadeIdealController,
    required this.observacoesController,
    required this.categoriaId,
    required this.isAtivo,
    required this.isSaving,
    required this.onCategoriaChanged,
    required this.onIsAtivoChanged,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final List<CategoriaEntity> categorias;
  final TextEditingController nomeController;
  final TextEditingController unidadeMedidaController;
  final TextEditingController marcaController;
  final TextEditingController quantidadeMinimaController;
  final TextEditingController quantidadeIdealController;
  final TextEditingController observacoesController;
  final int? categoriaId;
  final bool isAtivo;
  final bool isSaving;
  final ValueChanged<int?> onCategoriaChanged;
  final ValueChanged<bool> onIsAtivoChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: nomeController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Nome'),
            validator: _requiredValidator,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            initialValue: categoriaId,
            decoration: const InputDecoration(labelText: 'Categoria'),
            items: categorias
                .map(
                  (categoria) => DropdownMenuItem<int>(
                    value: categoria.id,
                    child: Text(
                      categoria.caminhoCompleto,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(growable: false),
            onChanged: onCategoriaChanged,
            validator: (value) {
              if (value == null) {
                return 'Selecione uma categoria.';
              }

              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: unidadeMedidaController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Unidade de medida'),
            validator: _requiredValidator,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: marcaController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Marca'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: quantidadeMinimaController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [_DecimalInputFormatter()],
                  decoration: const InputDecoration(
                    labelText: 'Quantidade minima',
                  ),
                  validator: _decimalValidator,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: quantidadeIdealController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [_DecimalInputFormatter()],
                  decoration: const InputDecoration(
                    labelText: 'Quantidade ideal',
                  ),
                  validator: _decimalValidator,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: observacoesController,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(labelText: 'Observacoes'),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Produto ativo'),
            value: isAtivo,
            onChanged: onIsAtivoChanged,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: isSaving ? null : onSubmit,
            icon: isSaving
                ? const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save_outlined),
            label: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obrigatorio.';
    }

    return null;
  }

  String? _decimalValidator(String? value) {
    final normalized = value?.replaceAll(',', '.').trim();

    if (normalized == null || normalized.isEmpty) {
      return 'Campo obrigatorio.';
    }

    final parsed = double.tryParse(normalized);

    if (parsed == null || parsed < 0) {
      return 'Informe um numero valido.';
    }

    return null;
  }
}

class _DecimalInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text.isEmpty || RegExp(r'^\d*([,.]\d*)?$').hasMatch(text)) {
      return newValue;
    }

    return oldValue;
  }
}

class _FormError extends StatelessWidget {
  const _FormError({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Nao foi possivel carregar o formulario.\n$error',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
