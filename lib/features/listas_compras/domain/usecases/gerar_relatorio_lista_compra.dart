import '../entities/lista_compra_entity.dart';
import '../entities/relatorio_lista_compra_entity.dart';
import '../entities/relatorio_lista_compra_item_entity.dart';

class GerarRelatorioListaCompra {
  const GerarRelatorioListaCompra({DateTime Function()? agora})
      : _agora = agora ?? DateTime.now;

  final DateTime Function() _agora;

  RelatorioListaCompraEntity call(ListaCompraEntity lista) {
    return RelatorioListaCompraEntity(
      listaId: lista.id,
      nome: lista.nome,
      status: lista.status,
      criadoEm: lista.criadoEm,
      concluidoEm: lista.concluidoEm,
      geradoEm: _agora(),
      itens: lista.itens
          .map(
            (item) => RelatorioListaCompraItemEntity(
              produtoNome: item.produtoNome,
              unidadeMedida: item.unidadeMedida,
              quantidadePlanejada: item.quantidadePlanejada,
              quantidadeComprada: item.quantidadeComprada,
              isComprado: item.isComprado,
              observacoes: item.observacoes,
            ),
          )
          .toList(growable: false),
    );
  }
}
