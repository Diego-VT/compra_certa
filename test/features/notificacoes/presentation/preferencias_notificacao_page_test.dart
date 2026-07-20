import 'package:compra_certa/features/notificacoes/application/notificacao_providers.dart';
import 'package:compra_certa/features/notificacoes/domain/entities/preferencias_notificacao_entity.dart';
import 'package:compra_certa/features/notificacoes/presentation/pages/preferencias_notificacao_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('exibe preferencias e estado ativo em tela compacta', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          preferenciasNotificacaoProvider.overrideWith(
            _FakePreferenciasNotificacaoController.new,
          ),
        ],
        child: const MaterialApp(home: PreferenciasNotificacaoPage()),
      ),
    );
    await tester.pump();

    expect(find.text('Notificações'), findsOneWidget);
    expect(find.text('Lembretes ativados'), findsOneWidget);
    expect(find.text('Estoque baixo'), findsOneWidget);
    expect(find.text('Listas pendentes'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Privacidade preservada'),
      200,
    );
    expect(find.text('Privacidade preservada'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _FakePreferenciasNotificacaoController
    extends PreferenciasNotificacaoController {
  @override
  Future<PreferenciasNotificacaoEntity> build() async {
    return const PreferenciasNotificacaoEntity();
  }
}
