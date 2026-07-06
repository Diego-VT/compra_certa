import 'package:drift/drift.dart';

import '../../../../database/app_database.dart';
import '../../domain/entities/sugestao_estoque_context.dart';
import '../../domain/entities/sugestao_inteligente_entity.dart';
import '../../domain/entities/sugestao_inteligente_filtro.dart';
import '../../domain/entities/sugestao_recorrencia_context.dart';
import '../../domain/services/motor_sugestoes_locais.dart';

abstract class SugestaoInteligenteLocalDataSource {
  Future<List<SugestaoInteligenteEntity>> gerarSugestoesLocais(
    SugestaoInteligenteFiltro filtro,
  );
}

class SugestaoInteligenteLocalDataSourceImpl
    implements SugestaoInteligenteLocalDataSource {
  const SugestaoInteligenteLocalDataSourceImpl(
    this._database, [
    this._motor = const MotorSugestoesLocais(),
  ]);

  final AppDatabase _database;
  final MotorSugestoesLocais _motor;

  @override
  Future<List<SugestaoInteligenteEntity>> gerarSugestoesLocais(
    SugestaoInteligenteFiltro filtro,
  ) async {
    _validarFiltro(filtro);

    final sugestoesEstoque = await _gerarSugestoesPorEstoqueBaixo(filtro);
    final produtosJaSugeridos = sugestoesEstoque
        .map((sugestao) => sugestao.produtoId)
        .toSet();
    final sugestoesRecorrencia = await _gerarSugestoesPorRecorrencia(
      filtro,
      produtosJaSugeridos,
    );

    return [
      ...sugestoesEstoque,
      ...sugestoesRecorrencia,
    ].take(filtro.limit).toList(growable: false);
  }

  Future<List<SugestaoInteligenteEntity>> _gerarSugestoesPorEstoqueBaixo(
    SugestaoInteligenteFiltro filtro,
  ) async {
    final query =
        _database.select(_database.produtos).join([
            leftOuterJoin(
              _database.estoques,
              _database.estoques.produtoId.equalsExp(_database.produtos.id),
            ),
          ])
          ..where(_database.produtos.isAtivo.equals(true))
          ..where(
            const CustomExpression<bool>(
              'COALESCE(estoques.quantidade_atual, 0) < produtos.quantidade_minima',
            ),
          )
          ..orderBy([OrderingTerm.asc(_database.produtos.nome)])
          ..limit(filtro.limit);

    final rows = await query.get();

    return rows
        .map((row) {
          final produto = row.readTable(_database.produtos);
          final estoque = row.readTableOrNull(_database.estoques);

          return _motor.gerarPorEstoqueBaixo(
            SugestaoEstoqueContext(
              produtoId: produto.id,
              produtoNome: produto.nome,
              unidadeMedida: produto.unidadeMedida,
              quantidadeAtual: estoque?.quantidadeAtual ?? 0,
              quantidadeMinima: produto.quantidadeMinima,
              quantidadeIdeal: produto.quantidadeIdeal,
            ),
          );
        })
        .toList(growable: false);
  }

  Future<List<SugestaoInteligenteEntity>> _gerarSugestoesPorRecorrencia(
    SugestaoInteligenteFiltro filtro,
    Set<int> produtosIgnorados,
  ) async {
    final rows = await _database
        .customSelect(
          '''
          WITH compras_recentes AS (
            SELECT id, data_compra
            FROM compras
            WHERE data_compra >= ?
            ORDER BY data_compra DESC, id DESC
            LIMIT ?
          )
          SELECT
            produtos.id AS produto_id,
            produtos.nome AS produto_nome,
            produtos.unidade_medida AS unidade_medida,
            produtos.quantidade_minima AS quantidade_minima,
            produtos.quantidade_ideal AS quantidade_ideal,
            COALESCE(estoques.quantidade_atual, 0) AS quantidade_atual,
            COUNT(DISTINCT compras.id) AS total_compras,
            AVG(itens_compra.quantidade) AS media_quantidade,
            MAX(compras.data_compra) AS ultima_compra
          FROM itens_compra
          INNER JOIN compras_recentes compras ON compras.id = itens_compra.compra_id
          INNER JOIN produtos ON produtos.id = itens_compra.produto_id
          LEFT JOIN estoques ON estoques.produto_id = produtos.id
          WHERE produtos.is_ativo = 1
          GROUP BY
            produtos.id,
            produtos.nome,
            produtos.unidade_medida,
            produtos.quantidade_minima,
            produtos.quantidade_ideal,
            estoques.quantidade_atual
          HAVING COUNT(DISTINCT compras.id) >= ?
          ORDER BY total_compras DESC, produtos.nome ASC
          LIMIT ?
          ''',
          variables: [
            Variable<DateTime>(filtro.inicioRecorrencia),
            Variable<int>(filtro.maxComprasRecentes),
            Variable<int>(filtro.minimoComprasRecorrentes),
            Variable<int>(filtro.limit),
          ],
          readsFrom: {
            _database.compras,
            _database.itensCompra,
            _database.produtos,
            _database.estoques,
          },
        )
        .get();

    return rows
        .where(
          (row) => !produtosIgnorados.contains(row.read<int>('produto_id')),
        )
        .map((row) {
          return _motor.gerarPorConsumoRecorrente(
            context: SugestaoRecorrenciaContext(
              produtoId: row.read<int>('produto_id'),
              produtoNome: row.read<String>('produto_nome'),
              unidadeMedida: row.read<String>('unidade_medida'),
              quantidadeAtual: row.read<double>('quantidade_atual'),
              quantidadeMinima: row.read<double>('quantidade_minima'),
              quantidadeIdeal: row.read<double>('quantidade_ideal'),
              totalComprasRecentes: row.read<int>('total_compras'),
              mediaQuantidade: row.read<double>('media_quantidade'),
              ultimaCompraEm: row.read<DateTime>('ultima_compra'),
            ),
            filtro: filtro,
          );
        })
        .toList(growable: false);
  }

  void _validarFiltro(SugestaoInteligenteFiltro filtro) {
    if (filtro.limit <= 0) {
      throw ArgumentError('Limite deve ser maior que zero.');
    }

    if (filtro.janelaRecorrenciaDias <= 0) {
      throw ArgumentError('Janela de recorrencia deve ser maior que zero.');
    }

    if (filtro.minimoComprasRecorrentes <= 0) {
      throw ArgumentError(
        'Minimo de compras recorrentes deve ser maior que zero.',
      );
    }

    if (filtro.maxComprasRecentes <= 0) {
      throw ArgumentError(
        'Maximo de compras recentes deve ser maior que zero.',
      );
    }
  }
}
