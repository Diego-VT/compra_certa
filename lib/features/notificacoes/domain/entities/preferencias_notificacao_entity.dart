class PreferenciasNotificacaoEntity {
  const PreferenciasNotificacaoEntity({
    this.notificacoesAtivas = true,
    this.alertarEstoqueBaixo = true,
    this.alertarListasPendentes = true,
  });

  final bool notificacoesAtivas;
  final bool alertarEstoqueBaixo;
  final bool alertarListasPendentes;

  PreferenciasNotificacaoEntity copyWith({
    bool? notificacoesAtivas,
    bool? alertarEstoqueBaixo,
    bool? alertarListasPendentes,
  }) {
    return PreferenciasNotificacaoEntity(
      notificacoesAtivas: notificacoesAtivas ?? this.notificacoesAtivas,
      alertarEstoqueBaixo: alertarEstoqueBaixo ?? this.alertarEstoqueBaixo,
      alertarListasPendentes:
          alertarListasPendentes ?? this.alertarListasPendentes,
    );
  }
}
