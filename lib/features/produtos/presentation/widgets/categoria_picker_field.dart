import 'package:flutter/material.dart';

import '../../../categorias/domain/entities/categoria_entity.dart';

class CategoriaPickerField extends StatelessWidget {
  const CategoriaPickerField({
    super.key,
    required this.categorias,
    required this.categoriaId,
    required this.onChanged,
    this.labelText = 'Categoria',
    this.allowAll = false,
    this.allLabel = 'Todas as categorias',
    this.emptyLabel = 'Selecione a categoria',
    this.validator,
  });

  final List<CategoriaEntity> categorias;
  final int? categoriaId;
  final ValueChanged<int?> onChanged;
  final String labelText;
  final bool allowAll;
  final String allLabel;
  final String emptyLabel;
  final FormFieldValidator<int?>? validator;

  @override
  Widget build(BuildContext context) {
    return FormField<int?>(
      initialValue: categoriaId,
      validator: validator,
      builder: (field) {
        final categoriaSelecionada = categorias
            .where((categoria) => categoria.id == field.value)
            .firstOrNull;
        final label =
            categoriaSelecionada?.caminhoCompleto ??
            (allowAll ? allLabel : emptyLabel);

        return InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () => _abrirSeletor(context, field),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: labelText,
              errorText: field.errorText,
              suffixIcon: const Icon(Icons.keyboard_arrow_down),
            ),
            child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        );
      },
    );
  }

  Future<void> _abrirSeletor(
    BuildContext context,
    FormFieldState<int?> field,
  ) async {
    final selection = await showModalBottomSheet<_CategoriaSelection>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return _CategoriaPicker(
          categorias: categorias,
          categoriaId: field.value,
          allowAll: allowAll,
          allLabel: allLabel,
        );
      },
    );

    if (selection == null) {
      return;
    }

    field.didChange(selection.categoriaId);
    onChanged(selection.categoriaId);
  }
}

class _CategoriaPicker extends StatefulWidget {
  const _CategoriaPicker({
    required this.categorias,
    required this.categoriaId,
    required this.allowAll,
    required this.allLabel,
  });

  final List<CategoriaEntity> categorias;
  final int? categoriaId;
  final bool allowAll;
  final String allLabel;

  @override
  State<_CategoriaPicker> createState() => _CategoriaPickerState();
}

class _CategoriaPickerState extends State<_CategoriaPicker> {
  late final Map<int?, List<CategoriaEntity>> _filhosPorPai;
  late final Map<int, CategoriaEntity> _categoriasPorId;
  late final Set<int> _categoriasAbertas;

  @override
  void initState() {
    super.initState();
    final categoriasAtivas = widget.categorias
        .where((categoria) => categoria.ativo)
        .toList(growable: false);

    _categoriasPorId = {
      for (final categoria in categoriasAtivas) categoria.id: categoria,
    };
    _filhosPorPai = _agruparFilhos(categoriasAtivas);
    _categoriasAbertas = _ancestraisDaCategoria(widget.categoriaId);
  }

  @override
  Widget build(BuildContext context) {
    final itensVisiveis = _itensVisiveis();
    final categoriaSelecionada = _categoriasPorId[widget.categoriaId];

    return SafeArea(
      child: FractionallySizedBox(
        heightFactor: 0.82,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
              child: Text(
                'Selecionar categoria',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            if (categoriaSelecionada != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                child: Text(
                  categoriaSelecionada.caminhoCompleto,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            if (widget.allowAll) ...[
              ListTile(
                leading: const Icon(Icons.all_inclusive),
                title: Text(widget.allLabel),
                selected: widget.categoriaId == null,
                onTap: () =>
                    Navigator.of(context).pop(const _CategoriaSelection(null)),
              ),
              const Divider(height: 1),
            ],
            Expanded(
              child: ListView.builder(
                itemCount: itensVisiveis.length,
                itemBuilder: (context, index) {
                  final item = itensVisiveis[index];

                  return _CategoriaAccordionTile(
                    categoria: item.categoria,
                    depth: item.depth,
                    isExpanded: _categoriasAbertas.contains(item.categoria.id),
                    isSelected: item.categoria.id == widget.categoriaId,
                    hasChildren: (_filhosPorPai[item.categoria.id] ?? const [])
                        .isNotEmpty,
                    onToggle: () => _alternarCategoria(item.categoria.id),
                    onSelect: () => Navigator.of(
                      context,
                    ).pop(_CategoriaSelection(item.categoria.id)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<int?, List<CategoriaEntity>> _agruparFilhos(
    List<CategoriaEntity> categorias,
  ) {
    final filhosPorPai = <int?, List<CategoriaEntity>>{};

    for (final categoria in categorias) {
      filhosPorPai
          .putIfAbsent(categoria.categoriaPaiId, () => [])
          .add(categoria);
    }

    for (final filhos in filhosPorPai.values) {
      filhos.sort((a, b) => a.nome.compareTo(b.nome));
    }

    return filhosPorPai;
  }

  Set<int> _ancestraisDaCategoria(int? categoriaId) {
    final abertos = <int>{};
    var categoriaAtual = categoriaId == null
        ? null
        : _categoriasPorId[categoriaId];

    while (categoriaAtual?.categoriaPaiId != null) {
      final paiId = categoriaAtual!.categoriaPaiId!;
      abertos.add(paiId);
      categoriaAtual = _categoriasPorId[paiId];
    }

    return abertos;
  }

  List<_CategoriaAccordionItem> _itensVisiveis() {
    final itens = <_CategoriaAccordionItem>[];

    void adicionarFilhos(int? paiId, int depth) {
      final filhos = _filhosPorPai[paiId] ?? const <CategoriaEntity>[];

      for (final filho in filhos) {
        itens.add(_CategoriaAccordionItem(categoria: filho, depth: depth));

        if (_categoriasAbertas.contains(filho.id)) {
          adicionarFilhos(filho.id, depth + 1);
        }
      }
    }

    adicionarFilhos(null, 0);

    return itens;
  }

  void _alternarCategoria(int categoriaId) {
    final temFilhos = (_filhosPorPai[categoriaId] ?? const []).isNotEmpty;

    if (!temFilhos) {
      Navigator.of(context).pop(_CategoriaSelection(categoriaId));
      return;
    }

    setState(() {
      if (!_categoriasAbertas.add(categoriaId)) {
        _categoriasAbertas.remove(categoriaId);
      }
    });
  }
}

class _CategoriaAccordionItem {
  const _CategoriaAccordionItem({required this.categoria, required this.depth});

  final CategoriaEntity categoria;
  final int depth;
}

class _CategoriaAccordionTile extends StatelessWidget {
  const _CategoriaAccordionTile({
    required this.categoria,
    required this.depth,
    required this.isExpanded,
    required this.isSelected,
    required this.hasChildren,
    required this.onToggle,
    required this.onSelect,
  });

  final CategoriaEntity categoria;
  final int depth;
  final bool isExpanded;
  final bool isSelected;
  final bool hasChildren;
  final VoidCallback onToggle;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isRoot = depth == 0;

    return ListTile(
      minLeadingWidth: 24,
      contentPadding: EdgeInsets.only(left: isRoot ? 16 : 32, right: 8),
      leading: Icon(
        hasChildren
            ? (isExpanded ? Icons.expand_more : Icons.chevron_right)
            : Icons.subdirectory_arrow_right,
        color: isSelected ? colorScheme.primary : null,
      ),
      title: Text(
        categoria.nome,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: isRoot ? Theme.of(context).textTheme.titleSmall : null,
      ),
      trailing: IconButton(
        tooltip: 'Selecionar categoria',
        onPressed: onSelect,
        icon: Icon(
          isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isSelected ? colorScheme.primary : null,
        ),
      ),
      selected: isSelected,
      onTap: onToggle,
    );
  }
}

class _CategoriaSelection {
  const _CategoriaSelection(this.categoriaId);

  final int? categoriaId;
}
