import 'package:compra_certa/database/app_database.dart';
import 'package:compra_certa/features/compras/data/datasources/compra_local_data_source.dart';
import 'package:compra_certa/features/compras/data/repositories/compra_repository_impl.dart';
import 'package:compra_certa/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:compra_certa/features/estoque/data/datasources/estoque_local_data_source.dart';
import 'package:compra_certa/features/estoque/data/repositories/estoque_repository_impl.dart';
import 'package:compra_certa/features/estoque/domain/entities/movimentacao_estoque_tipo.dart';
import 'package:compra_certa/features/estoque/domain/entities/registrar_movimentacao_estoque_data.dart';
import 'package:compra_certa/features/listas_compras/data/datasources/lista_compra_local_data_source.dart';
import 'package:compra_certa/features/listas_compras/data/repositories/lista_compra_repository_impl.dart';
import 'package:compra_certa/features/listas_compras/domain/entities/lista_compra_form_data.dart';
import 'package:compra_certa/features/compras/domain/entities/registrar_compra_data.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late DashboardRepositoryImpl repository;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());

    final estoqueRepository = EstoqueRepositoryImpl(
      localDataSource: EstoqueLocalDataSourceImpl(database),
    );
    final compraRepository = CompraRepositoryImpl(
      localDataSource: CompraLocalDataSourceImpl(database),
    );
    final listaCompraRepository = ListaCompraRepositoryImpl(
      localDataSource: ListaCompraLocalDataSourceImpl(database),
    );

    repository = DashboardRepositoryImpl(
      estoqueRepository: estoqueRepository,
      compraRepository: compraRepository,
      listaCompraRepository: listaCompraRepository,
    );

    await database.into(database.categorias).insert(
      CategoriasCompanion(
        id: const Value(1),
        nome: const Value('Alimentos'),
        nivel: const Value(1),
        caminhoCompleto: const Value('Alimentos'),
        origem: const Value('teste'),
      ),
    );

    await database.into(database.produtos).insert(
      ProdutosCompanion.insert(
        nome: 'Arroz',
        categoriaId: 1,
        unidadeMedida: 'kg',
        quantidadeMinima: const Value(2),
        quantidadeIdeal: const Value(5),
      ),
    );

    await database.into(database.produtos).insert(
      ProdutosCompanion.insert(
        nome: 'Cafe',
        categoriaId: 1,
        unidadeMedida: 'un',
        quantidadeMinima: const Value(1),
        quantidadeIdeal: const Value(2),
      ),
    );

    await estoqueRepository.registrarMovimentacao(
      const RegistrarMovimentacaoEstoqueData(
        produtoId: 1,
        tipo: MovimentacaoEstoqueTipo.ajuste,
        quantidade: 1,
      ),
    );
    await estoqueRepository.registrarMovimentacao(
      const RegistrarMovimentacaoEstoqueData(
        produtoId: 2,
        tipo: MovimentacaoEstoqueTipo.entrada,
        quantidade: 1,
      ),
    );

    final listaId = await listaCompraRepository.criarLista(
      const ListaCompraFormData(nome: 'Mercado da semana'),
    );
    await listaCompraRepository.adicionarItem(
      ListaCompraItemFormData(
        listaCompraId: listaId,
        produtoId: 1,
        quantidadePlanejada: 2,
      ),
    );

    await compraRepository.registrarCompra(
      RegistrarCompraData(
        dataCompra: DateTime(2026, 7, 3),
        observacoes: 'Compra semanal',
        itens: const [
          RegistrarCompraItemData(produtoId: 1, quantidade: 2),
        ],
      ),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('monta resumo do dashboard com indicadores basicos', () async {
    final resumo = await repository.obterResumo();

    expect(resumo.produtosAbaixoMinimo, hasLength(1));
    expect(resumo.produtosAbaixoMinimo.single.produtoNome, 'Arroz');
    expect(resumo.listasAbertas, hasLength(1));
    expect(resumo.listasAbertas.single.nome, 'Mercado da semana');
    expect(resumo.comprasRecentes, hasLength(1));
    expect(resumo.comprasRecentes.single.observacoes, 'Compra semanal');
  });
}
