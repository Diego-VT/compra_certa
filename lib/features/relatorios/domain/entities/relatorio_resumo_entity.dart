import 'relatorio_categoria_item_entity.dart';
import 'relatorio_produto_item_entity.dart';
import 'relatorio_resumo_periodo_entity.dart';

class RelatorioResumoEntity {
  const RelatorioResumoEntity({
    required this.periodo,
    required this.produtosMaisComprados,
    required this.consumoPorCategoria,
  });

  final RelatorioResumoPeriodoEntity periodo;
  final List<RelatorioProdutoItemEntity> produtosMaisComprados;
  final List<RelatorioCategoriaItemEntity> consumoPorCategoria;
}
