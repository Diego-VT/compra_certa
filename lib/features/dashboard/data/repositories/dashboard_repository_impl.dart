import '../../../compras/domain/entities/compra_filtro.dart';
import '../../../compras/domain/repositories/compra_repository.dart';
import '../../../estoque/domain/repositories/estoque_repository.dart';
import '../../../listas_compras/domain/entities/lista_compra_filtro.dart';
import '../../../listas_compras/domain/entities/lista_compra_status.dart';
import '../../../listas_compras/domain/repositories/lista_compra_repository.dart';
import '../../domain/entities/dashboard_resumo_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  const DashboardRepositoryImpl({
    required this.estoqueRepository,
    required this.compraRepository,
    required this.listaCompraRepository,
  });

  final EstoqueRepository estoqueRepository;
  final CompraRepository compraRepository;
  final ListaCompraRepository listaCompraRepository;

  @override
  Future<DashboardResumoEntity> obterResumo() async {
    final produtosAbaixoMinimo = await estoqueRepository.listarProdutosAbaixoMinimo();
    final listasAbertas = await listaCompraRepository.listarListas(
      const ListaCompraFiltro(status: ListaCompraStatus.aberta, limit: 5),
    );
    final comprasRecentes = await compraRepository.listarComprasPorPeriodo(
      const CompraFiltro(limit: 5),
    );

    return DashboardResumoEntity(
      produtosAbaixoMinimo: produtosAbaixoMinimo,
      listasAbertas: listasAbertas,
      comprasRecentes: comprasRecentes,
    );
  }
}
