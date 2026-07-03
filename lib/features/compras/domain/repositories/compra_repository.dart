import '../entities/compra_entity.dart';
import '../entities/compra_filtro.dart';
import '../entities/compra_list_item_entity.dart';
import '../entities/registrar_compra_data.dart';

abstract class CompraRepository {
  Future<CompraEntity> registrarCompra(RegistrarCompraData compra);

  Future<List<CompraListItemEntity>> listarComprasPorPeriodo(
    CompraFiltro filtro,
  );

  Future<CompraEntity?> obterCompraPorId(int id);
}
