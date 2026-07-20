import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../../application/lista_compra_providers.dart';
import '../../domain/entities/lista_compra_status.dart';
import '../../domain/entities/relatorio_lista_compra_entity.dart';
import '../../domain/entities/relatorio_lista_compra_item_entity.dart';

class RelatorioListaCompraPage extends ConsumerStatefulWidget {
  const RelatorioListaCompraPage({required this.listaId, super.key});

  final int listaId;

  @override
  ConsumerState<RelatorioListaCompraPage> createState() =>
      _RelatorioListaCompraPageState();
}

class _RelatorioListaCompraPageState
    extends ConsumerState<RelatorioListaCompraPage> {
  bool _compartilhando = false;

  @override
  Widget build(BuildContext context) {
    final relatorioState = ref.watch(
      relatorioListaCompraProvider(widget.listaId),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório da lista'),
        actions: [
          relatorioState.maybeWhen(
            data: (relatorio) => relatorio == null
                ? const SizedBox.shrink()
                : IconButton(
                    tooltip: 'Compartilhar PDF',
                    onPressed: _compartilhando
                        ? null
                        : () => _compartilhar(relatorio),
                    icon: _compartilhando
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.picture_as_pdf_outlined),
                  ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: relatorioState.when(
        data: (relatorio) => relatorio == null
            ? const Center(child: Text('Lista não encontrada.'))
            : _RelatorioContent(relatorio: relatorio),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 40),
                const SizedBox(height: 12),
                const Text('Não foi possível gerar o relatório.'),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () => ref.invalidate(
                    relatorioListaCompraProvider(widget.listaId),
                  ),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar novamente'),
                ),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<void> _compartilhar(RelatorioListaCompraEntity relatorio) async {
    setState(() => _compartilhando = true);
    try {
      final bytes = await ref
          .read(relatorioListaCompraPdfServiceProvider)
          .gerar(relatorio);
      await Printing.sharePdf(
        bytes: bytes,
        filename: '${_arquivoSeguro(relatorio.nome)}.pdf',
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível compartilhar o PDF.')),
        );
      }
    } finally {
      if (mounted) setState(() => _compartilhando = false);
    }
  }

  String _arquivoSeguro(String nome) {
    final normalizado = nome
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
    return normalizado.isEmpty ? 'lista_de_compras' : normalizado;
  }
}

class _RelatorioContent extends StatelessWidget {
  const _RelatorioContent({required this.relatorio});

  final RelatorioListaCompraEntity relatorio;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(relatorio.nome, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(
              relatorio.status == ListaCompraStatus.aberta
                  ? 'Lista aberta'
                  : 'Lista concluída',
            ),
            Text('Criada em ${_data(relatorio.criadoEm)}'),
            if (relatorio.concluidoEm != null)
              Text('Concluída em ${_data(relatorio.concluidoEm!)}'),
            const SizedBox(height: 16),
            _ProgressCard(relatorio: relatorio),
            const SizedBox(height: 20),
            Text('Itens', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (relatorio.itens.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(Icons.playlist_remove_outlined, size: 40),
                      SizedBox(height: 8),
                      Text('Esta lista ainda não possui itens.'),
                    ],
                  ),
                ),
              )
            else
              ...relatorio.itens.map((item) => _ItemCard(item: item)),
          ],
        ),
      ),
    );
  }

  String _data(DateTime value) =>
      '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.relatorio});

  final RelatorioListaCompraEntity relatorio;

  @override
  Widget build(BuildContext context) {
    final percentual = (relatorio.percentualConclusao * 100).round();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '$percentual% concluído',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text('${relatorio.totalComprados}/${relatorio.totalItens}'),
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(value: relatorio.percentualConclusao),
            const SizedBox(height: 10),
            Text('${relatorio.totalPendentes} item(ns) pendente(s)'),
          ],
        ),
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({required this.item});

  final RelatorioListaCompraItemEntity item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          item.isComprado ? Icons.check_circle : Icons.pending_outlined,
          color: item.isComprado ? Colors.green : null,
        ),
        title: Text(item.produtoNome),
        subtitle: Text(
          'Planejado: ${_numero(item.quantidadePlanejada)} ${item.unidadeMedida}\n'
          'Comprado: ${_numero(item.quantidadeComprada)} ${item.unidadeMedida}'
          '${item.observacoes?.trim().isNotEmpty == true ? '\n${item.observacoes}' : ''}',
        ),
        isThreeLine: true,
        trailing: Text(item.isComprado ? 'Comprado' : 'Pendente'),
      ),
    );
  }

  String _numero(double value) => value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(2).replaceAll('.', ',');
}
