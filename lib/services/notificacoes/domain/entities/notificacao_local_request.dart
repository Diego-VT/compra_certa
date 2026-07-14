class NotificacaoLocalRequest {
  const NotificacaoLocalRequest({
    required this.id,
    required this.chave,
    required this.titulo,
    required this.mensagem,
  });

  final int id;
  final String chave;
  final String titulo;
  final String mensagem;
}
