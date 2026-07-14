import 'package:drift/drift.dart';

import '../../../../database/app_database.dart';
import '../../domain/entities/relatorio_categoria_item_entity.dart';
import '../../domain/entities/relatorio_periodo_filtro.dart';
import '../../domain/entities/relatorio_produto_item_entity.dart';
import '../../domain/entities/relatorio_resumo_entity.dart';
import '../../domain/entities/relatorio_resumo_periodo_entity.dart';

abstract class RelatorioLocalDataSource {
  Future<RelatorioResumoEntity> obterResumo(RelatorioPeriodoFiltro filtro);
}

class RelatorioLocalDataSourceImpl implements RelatorioLocalDataSource {
  const RelatorioLocalDataSourceImpl(this._database);

  final AppDatabase _database;

  @override
  Future<RelatorioResumoEntity> obterResumo(
    RelatorioPeriodoFiltro filtro,
  ) async {
    _validarFiltro(filtro);

    final resumo = await _obterResumoPeriodo(filtro);
    final produtos = await _listarProdutosMaisComprados(filtro);
    final categorias = await _listarConsumoPorCategoria(filtro);

    return RelatorioResumoEntity(
      periodo: resumo,
      produtosMaisComprados: produtos,
      consumoPorCategoria: categorias,
    );
  }

  Future<RelatorioResumoPeriodoEntity> _obterResumoPeriodo(
    RelatorioPeriodoFiltro filtro,
  ) async {
    final row = await _database
        .customSelect(
          '''
          SELECT
            COUNT(DISTINCT compras.id) AS total_compras,
            COUNT(itens_compra.id) AS total_itens,
            COALESCE(SUM(itens_compra.quantidade), 0) AS quantidade_total,
            CASE
              WHEN COUNT(itens_compra.id) > 0
                AND COUNT(itens_compra.valor_unitario) = COUNT(itens_compra.id)
              THEN SUM(itens_compra.quantidade * itens_compra.valor_unitario)
              ELSE NULL
            END AS valor_total
          FROM compras
          LEFT JOIN itens_compra ON itens_compra.compra_id = compras.id
          WHERE ${_periodoWhereClause(filtro)}
          ''',
          variables: _periodoVariables(filtro),
          readsFrom: {_database.compras, _database.itensCompra},
        )
        .getSingle();

    return RelatorioResumoPeriodoEntity(
      totalCompras: row.read<int>('total_compras'),
      totalItens: row.read<int>('total_itens'),
      quantidadeTotal: row.read<double>('quantidade_total'),
      valorTotal: row.readNullable<double>('valor_total'),
    );
  }

  Future<List<RelatorioProdutoItemEntity>> _listarProdutosMaisComprados(
    RelatorioPeriodoFiltro filtro,
  ) async {
    final rows = await _database
        .customSelect(
          '''
          SELECT
            produtos.id AS produto_id,
            produtos.nome AS produto_nome,
            categorias.nome AS categoria_nome,
            produtos.unidade_medida AS unidade_medida,
            SUM(itens_compra.quantidade) AS quantidade_total,
            COUNT(itens_compra.id) AS total_registros,
            CASE
              WHEN COUNT(itens_compra.valor_unitario) = COUNT(itens_compra.id)
              THEN SUM(itens_compra.quantidade * itens_compra.valor_unitario)
              ELSE NULL
            END AS valor_total
          FROM itens_compra
          INNER JOIN compras ON compras.id = itens_compra.compra_id
          INNER JOIN produtos ON produtos.id = itens_compra.produto_id
          INNER JOIN categorias ON categorias.id = produtos.categoria_id
          WHERE ${_periodoWhereClause(filtro)}
          GROUP BY
            produtos.id,
            produtos.nome,
            categorias.nome,
            produtos.unidade_medida
          ORDER BY quantidade_total DESC, produtos.nome ASC
          LIMIT ?
          ''',
          variables: [..._periodoVariables(filtro), Variable<int>(filtro.limit)],
          readsFrom: {
            _database.compras,
            _database.itensCompra,
            _database.produtos,
            _database.categorias,
          },
        )
        .get();

    return rows
        .map(
          (row) => RelatorioProdutoItemEntity(
            produtoId: row.read<int>('produto_id'),
            produtoNome: row.read<String>('produto_nome'),
            categoriaNome: row.read<String>('categoria_nome'),
            unidadeMedida: row.read<String>('unidade_medida'),
            quantidadeTotal: row.read<double>('quantidade_total'),
            totalRegistros: row.read<int>('total_registros'),
            valorTotal: row.readNullable<double>('valor_total'),
          ),
        )
        .toList(growable: false);
  }

  Future<List<RelatorioCategoriaItemEntity>> _listarConsumoPorCategoria(
    RelatorioPeriodoFiltro filtro,
  ) async {
    final rows = await _database
        .customSelect(
          '''
          SELECT
            categorias.id AS categoria_id,
            categorias.nome AS categoria_nome,
            SUM(itens_compra.quantidade) AS quantidade_total,
            COUNT(DISTINCT produtos.id) AS total_produtos,
            COUNT(itens_compra.id) AS total_registros,
            CASE
              WHEN COUNT(itens_compra.valor_unitario) = COUNT(itens_compra.id)
              THEN SUM(itens_compra.quantidade * itens_compra.valor_unitario)
              ELSE NULL
            END AS valor_total
          FROM itens_compra
          INNER JOIN compras ON compras.id = itens_compra.compra_id
          INNER JOIN produtos ON produtos.id = itens_compra.produto_id
          INNER JOIN categorias ON categorias.id = produtos.categoria_id
          WHERE ${_periodoWhereClause(filtro)}
          GROUP BY categorias.id, categorias.nome
          ORDER BY quantidade_total DESC, categorias.nome ASC
          LIMIT ?
          ''',
          variables: [..._periodoVariables(filtro), Variable<int>(filtro.limit)],
          readsFrom: {
            _database.compras,
            _database.itensCompra,
            _database.produtos,
            _database.categorias,
          },
        )
        .get();

    return rows
        .map(
          (row) => RelatorioCategoriaItemEntity(
            categoriaId: row.read<int>('categoria_id'),
            categoriaNome: row.read<String>('categoria_nome'),
            quantidadeTotal: row.read<double>('quantidade_total'),
            totalProdutos: row.read<int>('total_produtos'),
            totalRegistros: row.read<int>('total_registros'),
            valorTotal: row.readNullable<double>('valor_total'),
          ),
        )
        .toList(growable: false);
  }

  String _periodoWhereClause(RelatorioPeriodoFiltro filtro) {
    final conditions = <String>[];

    if (filtro.inicio != null) {
      conditions.add('compras.data_compra >= ?');
    }

    if (filtro.fim != null) {
      conditions.add('compras.data_compra < ?');
    }

    if (conditions.isEmpty) {
      return '1 = 1';
    }

    return conditions.join(' AND ');
  }

  List<Variable<DateTime>> _periodoVariables(RelatorioPeriodoFiltro filtro) {
    final variables = <Variable<DateTime>>[];
    final inicio = filtro.inicio;
    final fim = filtro.fim;

    if (inicio != null) {
      variables.add(Variable<DateTime>(inicio));
    }

    if (fim != null) {
      variables.add(Variable<DateTime>(_fimExclusivo(fim)));
    }

    return variables;
  }

  DateTime _fimExclusivo(DateTime? fim) {
    if (fim == null) {
      return DateTime(9999);
    }

    return DateTime(fim.year, fim.month, fim.day).add(const Duration(days: 1));
  }

  void _validarFiltro(RelatorioPeriodoFiltro filtro) {
    if (filtro.limit <= 0) {
      throw ArgumentError('Limite deve ser maior que zero.');
    }

    final inicio = filtro.inicio;
    final fim = filtro.fim;

    if (inicio != null && fim != null && inicio.isAfter(fim)) {
      throw ArgumentError('Data inicial nao pode ser posterior a data final.');
    }
  }
}
