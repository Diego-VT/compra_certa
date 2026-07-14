import 'package:compra_certa/database/app_database.dart';
import 'package:compra_certa/features/produtos/data/datasources/produto_local_data_source.dart';
import 'package:compra_certa/features/produtos/domain/entities/produto_filtro.dart';
import 'package:compra_certa/features/produtos/domain/entities/produto_form_data.dart';
import 'package:compra_certa/features/produtos/data/models/produto_seed_model.dart';
import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late ProdutoLocalDataSource dataSource;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    dataSource = ProdutoLocalDataSourceImpl(database);

    await database
        .into(database.categorias)
        .insert(
          CategoriasCompanion(
            id: const Value(1),
            nome: const Value('Alimentos'),
            nivel: const Value(1),
            caminhoCompleto: const Value('Alimentos'),
            origem: const Value('teste'),
          ),
        );
    await database
        .into(database.categorias)
        .insert(
          CategoriasCompanion(
            id: const Value(2),
            nome: const Value('Limpeza'),
            nivel: const Value(1),
            caminhoCompleto: const Value('Limpeza'),
            origem: const Value('teste'),
          ),
        );
    await database
        .into(database.categorias)
        .insert(
          CategoriasCompanion(
            id: const Value(3),
            nome: const Value('Basico da Despensa'),
            categoriaPaiId: const Value(1),
            nivel: const Value(2),
            caminhoCompleto: const Value('Alimentos > Basico da Despensa'),
            origem: const Value('teste'),
          ),
        );
    await database
        .into(database.categorias)
        .insert(
          CategoriasCompanion(
            id: const Value(4),
            nome: const Value('Bebidas'),
            nivel: const Value(1),
            caminhoCompleto: const Value('Bebidas'),
            origem: const Value('teste'),
          ),
        );
    await database
        .into(database.categorias)
        .insert(
          CategoriasCompanion(
            id: const Value(5),
            nome: const Value('Refrigerantes'),
            categoriaPaiId: const Value(4),
            nivel: const Value(2),
            caminhoCompleto: const Value('Bebidas > Refrigerantes'),
            origem: const Value('teste'),
          ),
        );
  });

  tearDown(() async {
    await database.close();
  });

  test('cadastra produto relacionado a uma categoria', () async {
    final id = await dataSource.salvarProduto(
      const ProdutoFormData(
        nome: 'Arroz',
        categoriaId: 1,
        unidadeMedida: 'kg',
        marca: 'Marca A',
        quantidadeMinima: 1,
        quantidadeIdeal: 3,
        observacoes: 'Integral',
        isAtivo: true,
      ),
    );

    final produtos = await dataSource.listarProdutos();

    expect(id, isPositive);
    expect(produtos, hasLength(1));
    expect(produtos.single.nome, 'Arroz');
    expect(produtos.single.categoriaId, 1);
  });

  test('executa seed inicial de produtos apenas uma vez', () async {
    const produtosSeed = [
      ProdutoSeedModel(
        nome: 'Arroz',
        categoriaId: 1,
        unidadeMedida: 'kg',
        quantidadeMinima: 1,
        quantidadeIdeal: 5,
      ),
      ProdutoSeedModel(
        nome: 'Produto sem categoria',
        categoriaId: 999,
        unidadeMedida: 'un',
        quantidadeMinima: 1,
        quantidadeIdeal: 1,
      ),
    ];

    final primeiraExecucao = await dataSource.executarSeedInicial(
      seedKey: 'produtos_teste_v1',
      produtos: produtosSeed,
    );
    final segundaExecucao = await dataSource.executarSeedInicial(
      seedKey: 'produtos_teste_v1',
      produtos: produtosSeed,
    );
    final produtos = await dataSource.listarProdutos();

    expect(primeiraExecucao, 1);
    expect(segundaExecucao, 0);
    expect(produtos.map((produto) => produto.nome), ['Arroz']);
  });

  test('edita produto existente', () async {
    final id = await dataSource.salvarProduto(
      const ProdutoFormData(
        nome: 'Feijao',
        categoriaId: 1,
        unidadeMedida: 'kg',
        quantidadeMinima: 1,
        quantidadeIdeal: 2,
        isAtivo: true,
      ),
    );

    await dataSource.salvarProduto(
      ProdutoFormData(
        id: id,
        nome: 'Feijao carioca',
        categoriaId: 1,
        unidadeMedida: 'kg',
        quantidadeMinima: 2,
        quantidadeIdeal: 4,
        isAtivo: false,
      ),
    );

    final produto = await dataSource.buscarProdutoPorId(id);

    expect(produto?.nome, 'Feijao carioca');
    expect(produto?.quantidadeIdeal, 4);
    expect(produto?.isAtivo, isFalse);
    expect(produto?.atualizadoEm, isNotNull);
  });

  test('filtra produtos por busca categoria e status', () async {
    await dataSource.salvarProduto(
      const ProdutoFormData(
        nome: 'Arroz branco',
        categoriaId: 1,
        unidadeMedida: 'kg',
        quantidadeMinima: 1,
        quantidadeIdeal: 3,
        isAtivo: true,
      ),
    );
    await dataSource.salvarProduto(
      const ProdutoFormData(
        nome: 'Sabao em po',
        categoriaId: 2,
        unidadeMedida: 'un',
        quantidadeMinima: 1,
        quantidadeIdeal: 2,
        isAtivo: false,
      ),
    );

    final porBusca = await dataSource.listarProdutosParaExibicao(
      const ProdutoFiltro(busca: 'arroz', status: ProdutoStatusFiltro.todos),
    );
    final porCategoria = await dataSource.listarProdutosParaExibicao(
      const ProdutoFiltro(categoriaId: 2, status: ProdutoStatusFiltro.todos),
    );
    final inativos = await dataSource.listarProdutosParaExibicao(
      const ProdutoFiltro(status: ProdutoStatusFiltro.inativos),
    );

    expect(porBusca.map((produto) => produto.nome), ['Arroz branco']);
    expect(porCategoria.single.categoriaNome, 'Limpeza');
    expect(inativos.map((produto) => produto.nome), ['Sabao em po']);
  });

  test(
    'filtra categoria pai incluindo descendentes sem misturar secoes',
    () async {
      await dataSource.salvarProduto(
        const ProdutoFormData(
          nome: 'Cafe',
          categoriaId: 3,
          unidadeMedida: 'un',
          quantidadeMinima: 1,
          quantidadeIdeal: 2,
          isAtivo: true,
        ),
      );
      await dataSource.salvarProduto(
        const ProdutoFormData(
          nome: 'Refrigerante',
          categoriaId: 5,
          unidadeMedida: 'un',
          quantidadeMinima: 1,
          quantidadeIdeal: 2,
          isAtivo: true,
        ),
      );
      await dataSource.salvarProduto(
        const ProdutoFormData(
          nome: 'Sabao em po',
          categoriaId: 2,
          unidadeMedida: 'un',
          quantidadeMinima: 1,
          quantidadeIdeal: 2,
          isAtivo: true,
        ),
      );

      final alimentos = await dataSource.listarProdutosParaExibicao(
        const ProdutoFiltro(categoriaId: 1, status: ProdutoStatusFiltro.todos),
      );
      final bebidas = await dataSource.listarProdutosParaExibicao(
        const ProdutoFiltro(categoriaId: 4, status: ProdutoStatusFiltro.todos),
      );

      expect(alimentos.map((produto) => produto.nome), ['Cafe']);
      expect(
        alimentos.single.categoriaCaminho,
        'Alimentos > Basico da Despensa',
      );
      expect(bebidas.map((produto) => produto.nome), ['Refrigerante']);
      expect(bebidas.single.categoriaCaminho, 'Bebidas > Refrigerantes');
    },
  );

  test('busca trata caracteres especiais como texto literal', () async {
    await dataSource.salvarProduto(
      const ProdutoFormData(
        nome: 'Cafe 100% arabica',
        categoriaId: 1,
        unidadeMedida: 'un',
        quantidadeMinima: 1,
        quantidadeIdeal: 2,
        isAtivo: true,
      ),
    );
    await dataSource.salvarProduto(
      const ProdutoFormData(
        nome: 'Cafe 1000 arabica',
        categoriaId: 1,
        unidadeMedida: 'un',
        quantidadeMinima: 1,
        quantidadeIdeal: 2,
        isAtivo: true,
      ),
    );
    await dataSource.salvarProduto(
      const ProdutoFormData(
        nome: 'Sabao_em_po',
        categoriaId: 2,
        unidadeMedida: 'un',
        quantidadeMinima: 1,
        quantidadeIdeal: 2,
        isAtivo: true,
      ),
    );
    await dataSource.salvarProduto(
      const ProdutoFormData(
        nome: 'SabaoXemXpo',
        categoriaId: 2,
        unidadeMedida: 'un',
        quantidadeMinima: 1,
        quantidadeIdeal: 2,
        isAtivo: true,
      ),
    );

    final percentual = await dataSource.listarProdutosParaExibicao(
      const ProdutoFiltro(busca: '100%', status: ProdutoStatusFiltro.todos),
    );
    final sublinhado = await dataSource.listarProdutosParaExibicao(
      const ProdutoFiltro(busca: 'Sabao_', status: ProdutoStatusFiltro.todos),
    );

    expect(percentual.map((produto) => produto.nome), ['Cafe 100% arabica']);
    expect(sublinhado.map((produto) => produto.nome), ['Sabao_em_po']);
  });

  test('busca inteligente ignora acentos e combina campos do produto', () async {
    await dataSource.salvarProduto(
      const ProdutoFormData(
        nome: 'Café especial',
        categoriaId: 3,
        unidadeMedida: 'pct',
        marca: 'Torra Boa',
        quantidadeMinima: 1,
        quantidadeIdeal: 2,
        observacoes: 'Graos selecionados',
        isAtivo: true,
      ),
    );
    await dataSource.salvarProduto(
      const ProdutoFormData(
        nome: 'Detergente neutro',
        categoriaId: 2,
        unidadeMedida: 'un',
        marca: 'Casa Limpa',
        quantidadeMinima: 1,
        quantidadeIdeal: 2,
        isAtivo: true,
      ),
    );

    final semAcento = await dataSource.listarProdutosParaExibicao(
      const ProdutoFiltro(busca: 'cafe', status: ProdutoStatusFiltro.todos),
    );
    final porMarca = await dataSource.listarProdutosParaExibicao(
      const ProdutoFiltro(
        busca: 'torra cafe',
        status: ProdutoStatusFiltro.todos,
      ),
    );
    final porCategoria = await dataSource.listarProdutosParaExibicao(
      const ProdutoFiltro(
        busca: 'despensa cafe',
        status: ProdutoStatusFiltro.todos,
      ),
    );
    final porObservacao = await dataSource.listarProdutosParaExibicao(
      const ProdutoFiltro(busca: 'graos', status: ProdutoStatusFiltro.todos),
    );

    expect(semAcento.map((produto) => produto.nome), ['Café especial']);
    expect(porMarca.map((produto) => produto.nome), ['Café especial']);
    expect(porCategoria.map((produto) => produto.nome), ['Café especial']);
    expect(porObservacao.map((produto) => produto.nome), ['Café especial']);
  });

  test('altera status do produto sem remover do banco', () async {
    final id = await dataSource.salvarProduto(
      const ProdutoFormData(
        nome: 'Cafe',
        categoriaId: 1,
        unidadeMedida: 'un',
        quantidadeMinima: 1,
        quantidadeIdeal: 2,
        isAtivo: true,
      ),
    );

    await dataSource.alterarStatusProduto(id: id, isAtivo: false);

    final ativos = await dataSource.listarProdutosParaExibicao(
      const ProdutoFiltro(status: ProdutoStatusFiltro.ativos),
    );
    final todos = await dataSource.listarProdutosParaExibicao(
      const ProdutoFiltro(status: ProdutoStatusFiltro.todos),
    );
    final produto = await dataSource.buscarProdutoPorId(id);

    expect(ativos, isEmpty);
    expect(todos, hasLength(1));
    expect(produto?.isAtivo, isFalse);
  });
}
