import '../entities/ia_sugestao_request.dart';
import '../entities/ia_sugestao_response.dart';

abstract class IaClient {
  Future<IaSugestaoResponse> solicitarSugestao(IaSugestaoRequest request);
}
