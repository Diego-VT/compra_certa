import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../application/lista_compra_providers.dart';
import '../../application/listas_compras_paginadas_provider.dart';
import '../../domain/entities/lista_compra_form_data.dart';

class ListaCompraFormPage extends ConsumerStatefulWidget {
  const ListaCompraFormPage({super.key});

  @override
  ConsumerState<ListaCompraFormPage> createState() =>
      _ListaCompraFormPageState();
}

class _ListaCompraFormPageState extends ConsumerState<ListaCompraFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  bool _isSaving = false;

  bool get _podeSalvar => _nomeController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova lista')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome da lista',
                border: OutlineInputBorder(),
                helperText: 'Ex.: Mercado da semana',
              ),
              textInputAction: TextInputAction.done,
              onChanged: (_) => setState(() {}),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Informe o nome da lista.';
                }

                return null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: (_isSaving || !_podeSalvar) ? null : _salvar,
              icon: _isSaving
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: const Text('Salvar lista'),
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
      final id = await ref
          .read(criarListaCompraUseCaseProvider)
          .call(ListaCompraFormData(nome: _nomeController.text));

      ref.invalidate(listasComprasProvider);
      ref.read(listasComprasPaginadasProvider.notifier).resetar();

      if (mounted) {
        context.goNamed(
          AppRoute.detalheListaCompra.name,
          pathParameters: {'id': id.toString()},
        );
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
}
