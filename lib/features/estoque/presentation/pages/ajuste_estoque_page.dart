import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../application/estoque_providers.dart';
import '../../domain/entities/estoque_entity.dart';
import '../../domain/entities/movimentacao_estoque_tipo.dart';
import '../../domain/entities/registrar_movimentacao_estoque_data.dart';

class AjusteEstoquePage extends ConsumerStatefulWidget {
  const AjusteEstoquePage({required this.produtoId, super.key});

  final int produtoId;

  @override
  ConsumerState<AjusteEstoquePage> createState() => _AjusteEstoquePageState();
}

class _AjusteEstoquePageState extends ConsumerState<AjusteEstoquePage> {
  final _formKey = GlobalKey<FormState>();
  final _quantidadeController = TextEditingController();
  final _motivoController = TextEditingController();

  MovimentacaoEstoqueTipo _tipo = MovimentacaoEstoqueTipo.entrada;
  bool _isSaving = false;

  @override
  void dispose() {
    _quantidadeController.dispose();
    _motivoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final estoqueState = ref.watch(estoquePorProdutoProvider(widget.produtoId));

    return Scaffold(
      appBar: AppBar(title: const Text('Ajustar estoque')),
      body: estoqueState.when(
        data: (estoque) {
          if (estoque == null) {
            return const Center(child: Text('Produto nao encontrado.'));
          }

          return _AjusteEstoqueForm(
            formKey: _formKey,
            estoque: estoque,
            tipo: _tipo,
            quantidadeController: _quantidadeController,
            motivoController: _motivoController,
            isSaving: _isSaving,
            onTipoChanged: (tipo) => setState(() => _tipo = tipo),
            onSubmit: _salvarMovimentacao,
          );
        },
        error: (error, stackTrace) => _AjusteError(error: error),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<void> _salvarMovimentacao() async {
    final form = _formKey.currentState;

    if (form == null || !form.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    final movimentacao = RegistrarMovimentacaoEstoqueData(
      produtoId: widget.produtoId,
      tipo: _tipo,
      quantidade: _parseDecimal(_quantidadeController.text),
      motivo: _motivoController.text,
    );

    try {
      await ref
          .read(registrarMovimentacaoEstoqueUseCaseProvider)
          .call(movimentacao);
      ref.invalidate(resumoEstoqueProvider);
      ref.invalidate(produtosAbaixoMinimoProvider);
      ref.invalidate(estoquePorProdutoProvider(widget.produtoId));

      if (mounted) {
        context.goNamed(AppRoute.estoque.name);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nao foi possivel ajustar estoque: $error')),
        );
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

class _AjusteEstoqueForm extends StatelessWidget {
  const _AjusteEstoqueForm({
    required this.formKey,
    required this.estoque,
    required this.tipo,
    required this.quantidadeController,
    required this.motivoController,
    required this.isSaving,
    required this.onTipoChanged,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final EstoqueEntity estoque;
  final MovimentacaoEstoqueTipo tipo;
  final TextEditingController quantidadeController;
  final TextEditingController motivoController;
  final bool isSaving;
  final ValueChanged<MovimentacaoEstoqueTipo> onTipoChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(estoque.produtoNome, style: textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Atual: ${_formatNumber(estoque.quantidadeAtual)} ${estoque.unidadeMedida}',
          ),
          const SizedBox(height: 16),
          SegmentedButton<MovimentacaoEstoqueTipo>(
            segments: const [
              ButtonSegment(
                value: MovimentacaoEstoqueTipo.entrada,
                icon: Icon(Icons.add_circle_outline),
                label: Text('Entrada'),
              ),
              ButtonSegment(
                value: MovimentacaoEstoqueTipo.saida,
                icon: Icon(Icons.remove_circle_outline),
                label: Text('Saida'),
              ),
              ButtonSegment(
                value: MovimentacaoEstoqueTipo.ajuste,
                icon: Icon(Icons.tune),
                label: Text('Ajuste'),
              ),
            ],
            selected: {tipo},
            onSelectionChanged: (selection) {
              onTipoChanged(selection.single);
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: quantidadeController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [_DecimalInputFormatter()],
            decoration: InputDecoration(
              labelText: tipo == MovimentacaoEstoqueTipo.ajuste
                  ? 'Nova quantidade'
                  : 'Quantidade',
            ),
            validator: _decimalValidator,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: motivoController,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(labelText: 'Motivo'),
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
            label: const Text('Salvar movimentacao'),
          ),
        ],
      ),
    );
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(2);
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

class _AjusteError extends StatelessWidget {
  const _AjusteError({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Nao foi possivel carregar o ajuste.\n$error',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
