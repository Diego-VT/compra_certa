import 'package:compra_certa/features/inteligencia/domain/entities/sugestao_inteligente_entity.dart';
import 'package:compra_certa/features/inteligencia/domain/entities/sugestao_inteligente_filtro.dart';
import 'package:compra_certa/features/inteligencia/domain/entities/sugestao_inteligente_tipo.dart';
import 'package:compra_certa/features/inteligencia/domain/repositories/sugestao_inteligente_repository.dart';
import 'package:compra_certa/features/inteligencia/domain/usecases/gerar_sugestoes_locais.dart';
import 'package:compra_certa/features/inteligencia/domain/usecases/sanitizar_contexto_ia.dart';
import 'package:compra_certa/features/inteligencia/domain/usecases/solicitar_sugestao_externa.dart';
import 'package:compra_certa/services/ia/data/datasources/ia_prompt_asset_data_source.dart';
import 'package:compra_certa/services/ia/domain/entities/ia_sugestao_request.dart';
import 'package:compra_certa/services/ia/domain/entities/ia_sugestao_response.dart';
import 'package:compra_certa/services/ia/domain/repositories/ia_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('envia contexto sanitizado para IA externa sob demanda', () async {
    final iaClient = _CapturingIaClient(
      response: const IaSugestaoResponse(
        titulo: 'Prioridade de compra',
        mensagem: 'Compre arroz primeiro.',
      ),
    );
    final useCase = SolicitarSugestaoExterna(
      gerarSugestoesLocais: GerarSugestoesLocais(
        _FakeSugestaoRepository([
          _sugestao(
            produtoNome: '  Arroz   agulhinha tipo 1  ',
            motivo: 'Estoque abaixo do minimo',
          ),
        ]),
      ),
      sanitizarContextoIa: const SanitizarContextoIa(),
      promptDataSource: const _FakePromptDataSource(),
      iaClient: iaClient,
    );

    final result = await useCase.call();

    expect(result.usouFallback, isFalse);
    expect(result.titulo, 'Prioridade de compra');
    expect(iaClient.request?.promptVersion, 'ia_sugestoes_v1');
    expect(iaClient.request?.itens.single.produtoNome, 'Arroz agulhinha tipo 1');
    expect(iaClient.request?.toJson().toString(), isNot(contains('produtoId')));
    expect(iaClient.request?.toJson().toString(), isNot(contains('observacoes')));
  });

  test('retorna fallback local quando cliente de IA falha', () async {
    final useCase = SolicitarSugestaoExterna(
      gerarSugestoesLocais: GerarSugestoesLocais(
        _FakeSugestaoRepository([
          _sugestao(produtoNome: 'Cafe', motivo: 'Consumo recorrente'),
        ]),
      ),
      sanitizarContextoIa: const SanitizarContextoIa(),
      promptDataSource: const _FakePromptDataSource(),
      iaClient: const _FailingIaClient(),
    );

    final result = await useCase.call();

    expect(result.usouFallback, isTrue);
    expect(result.titulo, 'Sugestao local mantida');
    expect(result.mensagem, contains('IA externa nao respondeu'));
  });

  test('retorna fallback local quando prompt nao carrega', () async {
    final iaClient = _CapturingIaClient(
      response: const IaSugestaoResponse(titulo: 'IA', mensagem: 'OK'),
    );
    final useCase = SolicitarSugestaoExterna(
      gerarSugestoesLocais: GerarSugestoesLocais(
        _FakeSugestaoRepository([
          _sugestao(produtoNome: 'Cafe', motivo: 'Consumo recorrente'),
        ]),
      ),
      sanitizarContextoIa: const SanitizarContextoIa(),
      promptDataSource: const _FailingPromptDataSource(),
      iaClient: iaClient,
    );

    final result = await useCase.call();

    expect(result.usouFallback, isTrue);
    expect(result.titulo, 'Sugestao local mantida');
    expect(iaClient.request, isNull);
  });

  test('nao chama IA externa quando nao ha sugestoes locais', () async {
    final iaClient = _CapturingIaClient(
      response: const IaSugestaoResponse(titulo: 'IA', mensagem: 'OK'),
    );
    final useCase = SolicitarSugestaoExterna(
      gerarSugestoesLocais: GerarSugestoesLocais(
        _FakeSugestaoRepository(const []),
      ),
      sanitizarContextoIa: const SanitizarContextoIa(),
      promptDataSource: const _FakePromptDataSource(),
      iaClient: iaClient,
    );

    final result = await useCase.call();

    expect(result.usouFallback, isTrue);
    expect(result.titulo, 'Sem contexto para IA');
    expect(iaClient.request, isNull);
  });
}

SugestaoInteligenteEntity _sugestao({
  required String produtoNome,
  required String motivo,
}) {
  return SugestaoInteligenteEntity(
    tipo: SugestaoInteligenteTipo.estoqueBaixo,
    produtoId: 42,
    produtoNome: produtoNome,
    unidadeMedida: 'kg',
    quantidadeAtual: 1,
    quantidadeMinima: 2,
    quantidadeIdeal: 5,
    quantidadeSugerida: 4,
    motivo: motivo,
    explicacao: 'Contexto local explicavel.',
  );
}

class _FakeSugestaoRepository implements SugestaoInteligenteRepository {
  const _FakeSugestaoRepository(this.sugestoes);

  final List<SugestaoInteligenteEntity> sugestoes;

  @override
  Future<List<SugestaoInteligenteEntity>> gerarSugestoesLocais(
    SugestaoInteligenteFiltro filtro,
  ) async {
    return sugestoes;
  }
}

class _FakePromptDataSource implements IaPromptDataSource {
  const _FakePromptDataSource();

  @override
  Future<String> carregarPromptSugestoes() async {
    return 'Prompt v1';
  }
}

class _FailingPromptDataSource implements IaPromptDataSource {
  const _FailingPromptDataSource();

  @override
  Future<String> carregarPromptSugestoes() {
    throw Exception('asset ausente');
  }
}

class _CapturingIaClient implements IaClient {
  _CapturingIaClient({required this.response});

  final IaSugestaoResponse response;
  IaSugestaoRequest? request;

  @override
  Future<IaSugestaoResponse> solicitarSugestao(
    IaSugestaoRequest request,
  ) async {
    this.request = request;
    return response;
  }
}

class _FailingIaClient implements IaClient {
  const _FailingIaClient();

  @override
  Future<IaSugestaoResponse> solicitarSugestao(IaSugestaoRequest request) {
    throw Exception('sem rede');
  }
}
