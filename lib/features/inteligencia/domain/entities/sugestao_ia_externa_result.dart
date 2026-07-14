class SugestaoIaExternaResult {
  const SugestaoIaExternaResult({
    required this.titulo,
    required this.mensagem,
    required this.usouFallback,
  });

  final String titulo;
  final String mensagem;
  final bool usouFallback;
}
