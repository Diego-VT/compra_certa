import '../../../estoque/domain/usecases/listar_produtos_abaixo_minimo.dart';
import '../../../listas_compras/domain/entities/lista_compra_filtro.dart';
import '../../../listas_compras/domain/entities/lista_compra_status.dart';
import '../../../listas_compras/domain/usecases/listar_listas_compras.dart';
import '../entities/evento_notificavel_entity.dart';
import '../entities/notificacao_evento_tipo.dart';
import '../entities/preferencias_notificacao_entity.dart';

class DetectarEventosNotificaveis {
  const DetectarEventosNotificaveis({
    required this.listarProdutosAbaixoMinimo,
    required this.listarListasCompras,
  });

  final ListarProdutosAbaixoMinimo listarProdutosAbaixoMinimo;
  final ListarListasCompras listarListasCompras;

  Future<List<EventoNotificavelEntity>> call([
    PreferenciasNotificacaoEntity preferencias =
        const PreferenciasNotificacaoEntity(),
  ]) async {
    if (!preferencias.notificacoesAtivas) {
      return const [];
    }

    final eventos = <EventoNotificavelEntity>[];

    if (preferencias.alertarEstoqueBaixo) {
      final produtos = await listarProdutosAbaixoMinimo.call();

      eventos.addAll(
        produtos.map((produto) {
          final quantidadeNecessaria =
              produto.quantidadeMinima - produto.quantidadeAtual;

          return EventoNotificavelEntity(
            tipo: NotificacaoEventoTipo.estoqueBaixo,
            referenciaId: produto.produtoId,
            titulo: 'Reposicao necessaria',
            mensagem:
                '${produto.produtoNome} esta abaixo do minimo. Faltam ${_formatarQuantidade(quantidadeNecessaria)} ${produto.unidadeMedida}.',
          );
        }),
      );
    }

    if (preferencias.alertarListasPendentes) {
      final listas = await listarListasCompras.call(
        const ListaCompraFiltro(status: ListaCompraStatus.aberta),
      );

      eventos.addAll(
        listas.where((lista) => lista.totalItens > lista.totalComprados).map((lista) {
          final pendentes = lista.totalItens - lista.totalComprados;

          return EventoNotificavelEntity(
            tipo: NotificacaoEventoTipo.listaPendente,
            referenciaId: lista.id,
            titulo: 'Lista de compras pendente',
            mensagem:
                '${lista.nome} tem $pendentes item(ns) pendente(s) para compra.',
          );
        }),
      );
    }

    return eventos;
  }

  String _formatarQuantidade(double valor) {
    if (valor == valor.roundToDouble()) {
      return valor.toInt().toString();
    }

    return valor.toStringAsFixed(2);
  }
}
