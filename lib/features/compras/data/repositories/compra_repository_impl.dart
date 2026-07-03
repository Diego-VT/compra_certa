import '../../domain/entities/compra_entity.dart';
import '../../domain/entities/compra_filtro.dart';
import '../../domain/entities/compra_list_item_entity.dart';
import '../../domain/entities/registrar_compra_data.dart';
import '../../domain/repositories/compra_repository.dart';
import '../datasources/compra_local_data_source.dart';

class CompraRepositoryImpl implements CompraRepository {
  const CompraRepositoryImpl({required this.localDataSource});

  final CompraLocalDataSource localDataSource;

  @override
  Future<List<CompraListItemEntity>> listarComprasPorPeriodo(
    CompraFiltro filtro,
  ) {
    return localDataSource.listarComprasPorPeriodo(filtro);
  }

  @override
  Future<CompraEntity?> obterCompraPorId(int id) {
    return localDataSource.obterCompraPorId(id);
  }

  @override
  Future<CompraEntity> registrarCompra(RegistrarCompraData compra) {
    return localDataSource.registrarCompra(compra);
  }
}
