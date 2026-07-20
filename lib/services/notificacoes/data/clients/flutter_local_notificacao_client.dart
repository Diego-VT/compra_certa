import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../domain/entities/notificacao_local_request.dart';
import '../../domain/repositories/notificacao_local_client.dart';

class FlutterLocalNotificacaoClient implements NotificacaoLocalClient {
  FlutterLocalNotificacaoClient([FlutterLocalNotificationsPlugin? plugin])
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const _channelId = 'compra_certa_lembretes';
  static const _channelName = 'Lembretes de compras';
  static const _channelDescription =
      'Alertas de estoque baixo e listas de compras pendentes.';

  final FlutterLocalNotificationsPlugin _plugin;
  Future<void>? _initialization;

  @override
  Future<void> inicializar() => _initialization ??= _initialize();

  Future<void> _initialize() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
    await _plugin.initialize(settings: settings);
  }

  @override
  Future<bool> solicitarPermissao() async {
    await inicializar();
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      return await ios.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
    return true;
  }

  @override
  Future<void> agendar(NotificacaoLocalRequest request) async {
    await inicializar();
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    await _plugin.show(
      id: request.id,
      title: request.titulo,
      body: request.mensagem,
      notificationDetails: details,
      payload: request.chave,
    );
  }

  @override
  Future<void> cancelar(int id) async {
    await inicializar();
    await _plugin.cancel(id: id);
  }

  @override
  Future<void> cancelarTodos() async {
    await inicializar();
    await _plugin.cancelAll();
  }
}
