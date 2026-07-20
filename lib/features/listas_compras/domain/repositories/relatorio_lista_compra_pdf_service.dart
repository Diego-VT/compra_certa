import 'dart:typed_data';

import '../entities/relatorio_lista_compra_entity.dart';

abstract class RelatorioListaCompraPdfService {
  Future<Uint8List> gerar(RelatorioListaCompraEntity relatorio);
}
