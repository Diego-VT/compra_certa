import '../../domain/entities/ia_sugestao_request.dart';
import '../../domain/entities/ia_sugestao_response.dart';
import '../../domain/repositories/ia_client.dart';

class IaServiceUnavailableException implements Exception {
  const IaServiceUnavailableException(this.message);

  final String message;

  @override
  String toString() => message;
}

class IaDisabledClient implements IaClient {
  const IaDisabledClient();

  @override
  Future<IaSugestaoResponse> solicitarSugestao(IaSugestaoRequest request) {
    throw const IaServiceUnavailableException(
      'IA externa nao configurada para este ambiente.',
    );
  }
}
