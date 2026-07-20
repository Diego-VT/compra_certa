import 'package:compra_certa/features/notificacoes/data/datasources/preferencias_notificacao_local_data_source.dart';
import 'package:compra_certa/features/notificacoes/domain/entities/preferencias_notificacao_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('usa preferencias ativas por padrao', () async {
    const dataSource = PreferenciasNotificacaoLocalDataSource();

    final preferencias = await dataSource.obter();

    expect(preferencias.notificacoesAtivas, isTrue);
    expect(preferencias.alertarEstoqueBaixo, isTrue);
    expect(preferencias.alertarListasPendentes, isTrue);
  });

  test('persiste preferencias entre leituras', () async {
    const dataSource = PreferenciasNotificacaoLocalDataSource();
    const alteradas = PreferenciasNotificacaoEntity(
      notificacoesAtivas: true,
      alertarEstoqueBaixo: false,
      alertarListasPendentes: true,
    );

    await dataSource.salvar(alteradas);
    final preferencias = await dataSource.obter();

    expect(preferencias.notificacoesAtivas, isTrue);
    expect(preferencias.alertarEstoqueBaixo, isFalse);
    expect(preferencias.alertarListasPendentes, isTrue);
  });
}
