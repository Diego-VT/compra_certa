import 'package:compra_certa/features/inteligencia/domain/entities/sugestao_estoque_context.dart';
import 'package:compra_certa/features/inteligencia/domain/entities/sugestao_inteligente_filtro.dart';
import 'package:compra_certa/features/inteligencia/domain/entities/sugestao_inteligente_tipo.dart';
import 'package:compra_certa/features/inteligencia/domain/entities/sugestao_recorrencia_context.dart';
import 'package:compra_certa/features/inteligencia/domain/services/motor_sugestoes_locais.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const motor = MotorSugestoesLocais();

  test('calcula sugestao por estoque baixo com explicacao', () {
    final sugestao = motor.gerarPorEstoqueBaixo(
      const SugestaoEstoqueContext(
        produtoId: 1,
        produtoNome: 'Arroz',
        unidadeMedida: 'kg',
        quantidadeAtual: 1,
        quantidadeMinima: 2,
        quantidadeIdeal: 5,
      ),
    );

    expect(sugestao.tipo, SugestaoInteligenteTipo.estoqueBaixo);
    expect(sugestao.quantidadeSugerida, 4);
    expect(sugestao.explicacao, contains('minimo 2'));
  });

  test(
    'calcula sugestao recorrente usando media quando estoque esta adequado',
    () {
      final sugestao = motor.gerarPorConsumoRecorrente(
        context: SugestaoRecorrenciaContext(
          produtoId: 2,
          produtoNome: 'Cafe',
          unidadeMedida: 'un',
          quantidadeAtual: 4,
          quantidadeMinima: 1,
          quantidadeIdeal: 4,
          totalComprasRecentes: 2,
          mediaQuantidade: 3,
          ultimaCompraEm: DateTime(2026, 7, 1),
        ),
        filtro: SugestaoInteligenteFiltro(dataReferencia: DateTime(2026, 7, 6)),
      );

      expect(sugestao.tipo, SugestaoInteligenteTipo.consumoRecorrente);
      expect(sugestao.quantidadeSugerida, 3);
      expect(sugestao.explicacao, contains('2 compras'));
    },
  );
}
