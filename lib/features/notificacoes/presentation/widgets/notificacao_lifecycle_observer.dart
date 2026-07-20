import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/notificacao_providers.dart';

class NotificacaoLifecycleObserver extends ConsumerStatefulWidget {
  const NotificacaoLifecycleObserver({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<NotificacaoLifecycleObserver> createState() =>
      _NotificacaoLifecycleObserverState();
}

class _NotificacaoLifecycleObserverState
    extends ConsumerState<NotificacaoLifecycleObserver>
    with WidgetsBindingObserver {
  bool _sincronizando = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _sincronizar());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_sincronizar());
    }
  }

  Future<void> _sincronizar() async {
    if (_sincronizando || !mounted) return;
    _sincronizando = true;
    try {
      final preferencias = await ref.read(
        preferenciasNotificacaoProvider.future,
      );
      await ref
          .read(sincronizarEventosNotificaveisUseCaseProvider)
          .call(preferencias);
      ref.invalidate(eventosNotificaveisProvider);
    } catch (_) {
      // Notificacoes sao auxiliares e nunca devem impedir o uso do app.
    } finally {
      _sincronizando = false;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
