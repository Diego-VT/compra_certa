import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/compra_certa_app.dart';
import 'features/notificacoes/presentation/widgets/notificacao_lifecycle_observer.dart';

void main() {
  runApp(
    const ProviderScope(
      child: NotificacaoLifecycleObserver(child: CompraCertaApp()),
    ),
  );
}
