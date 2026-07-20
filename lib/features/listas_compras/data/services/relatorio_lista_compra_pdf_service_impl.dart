import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../domain/entities/lista_compra_status.dart';
import '../../domain/entities/relatorio_lista_compra_entity.dart';
import '../../domain/repositories/relatorio_lista_compra_pdf_service.dart';

class RelatorioListaCompraPdfServiceImpl
    implements RelatorioListaCompraPdfService {
  RelatorioListaCompraPdfServiceImpl();

  @override
  Future<Uint8List> gerar(RelatorioListaCompraEntity relatorio) async {
    final regular = pw.Font.ttf(
      await rootBundle.load('assets/fonts/roboto-regular.ttf'),
    );
    final bold = pw.Font.ttf(
      await rootBundle.load('assets/fonts/roboto-bold.ttf'),
    );
    final document = pw.Document(
      title: 'Lista de compras - ${relatorio.nome}',
      author: 'CompraCerta',
    );

    document.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(base: regular, bold: bold),
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 16),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'CompraCerta',
                style: pw.TextStyle(
                  color: PdfColors.green800,
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text('Relatorio da lista'),
            ],
          ),
        ),
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'Pagina ${context.pageNumber} de ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
          ),
        ),
        build: (context) => [
          pw.Text(
            relatorio.nome,
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            '${_status(relatorio.status)} | Criada em ${_data(relatorio.criadoEm)}',
          ),
          if (relatorio.concluidoEm != null)
            pw.Text('Concluida em ${_data(relatorio.concluidoEm!)}'),
          pw.SizedBox(height: 20),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                _summary('Itens', relatorio.totalItens.toString()),
                _summary('Comprados', relatorio.totalComprados.toString()),
                _summary('Pendentes', relatorio.totalPendentes.toString()),
                _summary(
                  'Conclusao',
                  '${(relatorio.percentualConclusao * 100).round()}%',
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          if (relatorio.itens.isEmpty)
            pw.Text('Esta lista nao possui itens.')
          else
            pw.TableHelper.fromTextArray(
              headers: const [
                'Produto',
                'Planejado',
                'Comprado',
                'Situacao',
                'Observacoes',
              ],
              data: relatorio.itens
                  .map(
                    (item) => [
                      item.produtoNome,
                      '${_numero(item.quantidadePlanejada)} ${item.unidadeMedida}',
                      '${_numero(item.quantidadeComprada)} ${item.unidadeMedida}',
                      item.isComprado ? 'Comprado' : 'Pendente',
                      item.observacoes?.trim() ?? '',
                    ],
                  )
                  .toList(growable: false),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.green700,
              ),
              headerStyle: pw.TextStyle(
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
              ),
              cellStyle: const pw.TextStyle(fontSize: 9),
              cellPadding: const pw.EdgeInsets.all(6),
            ),
          pw.SizedBox(height: 16),
          pw.Text(
            'Gerado em ${_dataHora(relatorio.geradoEm)}.',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
          ),
        ],
      ),
    );

    return document.save();
  }

  pw.Widget _summary(String label, String value) {
    return pw.Column(
      children: [
        pw.Text(value, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text(label, style: const pw.TextStyle(fontSize: 9)),
      ],
    );
  }

  String _status(ListaCompraStatus status) => switch (status) {
        ListaCompraStatus.aberta => 'Lista aberta',
        ListaCompraStatus.concluida => 'Lista concluida',
      };

  String _data(DateTime value) =>
      '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';

  String _dataHora(DateTime value) =>
      '${_data(value)} ${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';

  String _numero(double value) => value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(2).replaceAll('.', ',');
}
