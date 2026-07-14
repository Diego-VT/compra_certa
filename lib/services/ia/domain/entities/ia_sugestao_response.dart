class IaSugestaoResponse {
  const IaSugestaoResponse({
    required this.titulo,
    required this.mensagem,
    this.usouFallback = false,
  });

  final String titulo;
  final String mensagem;
  final bool usouFallback;
}
