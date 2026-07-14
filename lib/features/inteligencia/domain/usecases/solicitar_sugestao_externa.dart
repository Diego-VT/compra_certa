import '../../../../services/ia/data/datasources/ia_prompt_asset_data_source.dart';
import '../../../../services/ia/domain/entities/ia_sugestao_request.dart';
import '../../../../services/ia/domain/repositories/ia_client.dart';
import '../entities/sugestao_ia_externa_result.dart';
import '../entities/sugestao_inteligente_filtro.dart';
import 'gerar_sugestoes_locais.dart';
import 'sanitizar_contexto_ia.dart';

class SolicitarSugestaoExterna {
  const SolicitarSugestaoExterna({
    required this.gerarSugestoesLocais,
    required this.sanitizarContextoIa,
    required this.promptDataSource,
    required this.iaClient,
    this.promptVersion = 'ia_sugestoes_v1',
  });

  final GerarSugestoesLocais gerarSugestoesLocais;
  final SanitizarContextoIa sanitizarContextoIa;
  final IaPromptDataSource promptDataSource;
  final IaClient iaClient;
  final String promptVersion;

  Future<SugestaoIaExternaResult> call([
    SugestaoInteligenteFiltro filtro = const SugestaoInteligenteFiltro(),
  ]) async {
    final sugestoesLocais = await gerarSugestoesLocais.call(filtro);

    if (sugestoesLocais.isEmpty) {
      return const SugestaoIaExternaResult(
        titulo: 'Sem contexto para IA',
        mensagem:
            'O motor local nao encontrou sugestoes suficientes para enviar a IA.',
        usouFallback: true,
      );
    }

    try {
      final contextoSanitizado = sanitizarContextoIa.call(sugestoesLocais);
      final prompt = await promptDataSource.carregarPromptSugestoes();
      final resposta = await iaClient.solicitarSugestao(
        IaSugestaoRequest(
          promptVersion: promptVersion,
          prompt: prompt,
          itens: contextoSanitizado,
        ),
      );

      return SugestaoIaExternaResult(
        titulo: resposta.titulo,
        mensagem: resposta.mensagem,
        usouFallback: resposta.usouFallback,
      );
    } catch (_) {
      final total = sugestoesLocais.length;

      return SugestaoIaExternaResult(
        titulo: 'Sugestao local mantida',
        mensagem:
            'A IA externa nao respondeu agora. Use as $total sugestao(oes) locais geradas no aparelho.',
        usouFallback: true,
      );
    }
  }
}
