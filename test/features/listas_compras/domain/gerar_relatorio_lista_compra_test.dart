import 'package:compra_certa/features/listas_compras/data/services/relatorio_lista_compra_pdf_service_impl.dart';
import 'package:compra_certa/features/listas_compras/domain/entities/lista_compra_entity.dart';
import 'package:compra_certa/features/listas_compras/domain/entities/lista_compra_item_entity.dart';
import 'package:compra_certa/features/listas_compras/domain/entities/lista_compra_status.dart';
import 'package:compra_certa/features/listas_compras/domain/usecases/gerar_relatorio_lista_compra.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final geradoEm = DateTime(2026, 7, 20, 15, 30);
  final useCase = GerarRelatorioListaCompra(agora: () => geradoEm);

  test('calcula resumo e preserva quantidades dos itens', () {
    final relatorio = useCase.call(_listaComItens());

    expect(relatorio.nome, 'Mercado da semana');
    expect(relatorio.totalItens, 2);
    expect(relatorio.totalComprados, 1);
    expect(relatorio.totalPendentes, 1);
    expect(relatorio.percentualConclusao, 0.5);
    expect(relatorio.geradoEm, geradoEm);
    expect(relatorio.itens.first.quantidadePlanejada, 2);
    expect(relatorio.itens.first.quantidadeComprada, 2);
  });

  test('lista vazia gera resumo zerado', () {
    final relatorio = useCase.call(
      ListaCompraEntity(
        id: 2,
        nome: 'Lista vazia',
        status: ListaCompraStatus.aberta,
        criadoEm: DateTime(2026, 7, 20),
        itens: const [],
      ),
    );

    expect(relatorio.totalItens, 0);
    expect(relatorio.totalPendentes, 0);
    expect(relatorio.percentualConclusao, 0);
  });

  test('gera documento PDF valido', () async {
    final relatorio = useCase.call(_listaComItens());

    final bytes = await const RelatorioListaCompraPdfServiceImpl().gerar(
      relatorio,
    );

    expect(bytes.length, greaterThan(500));
    expect(String.fromCharCodes(bytes.take(4)), '%PDF');
  });
}

ListaCompraEntity _listaComItens() {
  return ListaCompraEntity(
    id: 1,
    nome: 'Mercado da semana',
    status: ListaCompraStatus.aberta,
    criadoEm: DateTime(2026, 7, 18),
    itens: [
      ListaCompraItemEntity(
        id: 1,
        listaCompraId: 1,
        produtoId: 10,
        produtoNome: 'Arroz',
        unidadeMedida: 'kg',
        quantidadePlanejada: 2,
        quantidadeComprada: 2,
        isComprado: true,
        criadoEm: DateTime(2026, 7, 18),
      ),
      ListaCompraItemEntity(
        id: 2,
        listaCompraId: 1,
        produtoId: 11,
        produtoNome: 'Cafe',
        unidadeMedida: 'un',
        quantidadePlanejada: 1,
        quantidadeComprada: 0,
        isComprado: false,
        criadoEm: DateTime(2026, 7, 18),
        observacoes: 'Preferir embalagem grande',
      ),
    ],
  );
}
