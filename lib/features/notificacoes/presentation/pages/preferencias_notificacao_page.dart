import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/notificacao_providers.dart';
import '../../domain/entities/preferencias_notificacao_entity.dart';

class PreferenciasNotificacaoPage extends ConsumerStatefulWidget {
  const PreferenciasNotificacaoPage({super.key});

  @override
  ConsumerState<PreferenciasNotificacaoPage> createState() =>
      _PreferenciasNotificacaoPageState();
}

class _PreferenciasNotificacaoPageState
    extends ConsumerState<PreferenciasNotificacaoPage> {
  bool _sincronizando = false;

  @override
  Widget build(BuildContext context) {
    final preferenciasState = ref.watch(preferenciasNotificacaoProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notificações')),
      body: preferenciasState.when(
        data: _buildContent,
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 40),
                const SizedBox(height: 12),
                const Text('Não foi possível carregar as preferências.'),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () =>
                      ref.invalidate(preferenciasNotificacaoProvider),
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildContent(PreferenciasNotificacaoEntity preferencias) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _NotificationStatusCard(
              isActive: preferencias.notificacoesAtivas,
            ),
            const SizedBox(height: 20),
            Text(
              'Preferências',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.notifications_outlined),
                    title: const Text('Ativar notificações'),
                    subtitle: const Text(
                      'Receba lembretes locais, mesmo sem internet.',
                    ),
                    value: preferencias.notificacoesAtivas,
                    onChanged: _sincronizando
                        ? null
                        : (value) => _atualizar(
                              preferencias.copyWith(
                                notificacoesAtivas: value,
                              ),
                              solicitarPermissao: value,
                            ),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    secondary: const Icon(Icons.inventory_2_outlined),
                    title: const Text('Estoque baixo'),
                    subtitle: const Text(
                      'Avisar quando um produto precisar de reposição.',
                    ),
                    value: preferencias.alertarEstoqueBaixo,
                    onChanged:
                        preferencias.notificacoesAtivas && !_sincronizando
                            ? (value) => _atualizar(
                                  preferencias.copyWith(
                                    alertarEstoqueBaixo: value,
                                  ),
                                )
                            : null,
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    secondary: const Icon(Icons.list_alt_outlined),
                    title: const Text('Listas pendentes'),
                    subtitle: const Text(
                      'Avisar sobre listas abertas com itens por comprar.',
                    ),
                    value: preferencias.alertarListasPendentes,
                    onChanged:
                        preferencias.notificacoesAtivas && !_sincronizando
                            ? (value) => _atualizar(
                                  preferencias.copyWith(
                                    alertarListasPendentes: value,
                                  ),
                                )
                            : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: preferencias.notificacoesAtivas && !_sincronizando
                  ? () => _sincronizar(preferencias, solicitarPermissao: true)
                  : null,
              icon: _sincronizando
                  ? SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.onPrimary,
                      ),
                    )
                  : const Icon(Icons.sync),
              label: const Text('Atualizar lembretes agora'),
            ),
            const SizedBox(height: 16),
            Card(
              color: colorScheme.surfaceContainerLow,
              child: const ListTile(
                leading: Icon(Icons.lock_outline),
                title: Text('Privacidade preservada'),
                subtitle: Text(
                  'Os lembretes são calculados no aparelho. Nenhum dado é enviado pela internet.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _atualizar(
    PreferenciasNotificacaoEntity preferencias, {
    bool solicitarPermissao = false,
  }) async {
    await ref.read(preferenciasNotificacaoProvider.notifier).salvar(preferencias);
    if (!mounted) return;

    final salvamento = ref.read(preferenciasNotificacaoProvider);
    if (salvamento.hasError) {
      _mostrarMensagem('Não foi possível salvar as preferências.');
      return;
    }
    await _sincronizar(
      preferencias,
      solicitarPermissao: solicitarPermissao,
    );
  }

  Future<void> _sincronizar(
    PreferenciasNotificacaoEntity preferencias, {
    bool solicitarPermissao = false,
  }) async {
    setState(() => _sincronizando = true);
    try {
      final total = await ref
          .read(sincronizarEventosNotificaveisUseCaseProvider)
          .call(
            preferencias,
            solicitarPermissao: solicitarPermissao,
          );
      ref.invalidate(eventosNotificaveisProvider);
      if (mounted) {
        _mostrarMensagem(
          preferencias.notificacoesAtivas
              ? '$total lembrete(s) atualizado(s).'
              : 'Notificacoes desativadas.',
        );
      }
    } catch (error) {
      if (mounted) {
        _mostrarMensagem('Não foi possível atualizar os lembretes.');
      }
    } finally {
      if (mounted) setState(() => _sincronizando = false);
    }
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(mensagem)));
  }
}

class _NotificationStatusCard extends StatelessWidget {
  const _NotificationStatusCard({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final background = isActive
        ? colorScheme.primaryContainer
        : colorScheme.surfaceContainerHighest;
    final foreground = isActive
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSurfaceVariant;

    return Card(
      color: background,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: foreground.withValues(alpha: 0.12),
              child: Icon(
                isActive
                    ? Icons.notifications_active_outlined
                    : Icons.notifications_off_outlined,
                color: foreground,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isActive
                        ? 'Lembretes ativados'
                        : 'Lembretes desativados',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: foreground,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isActive
                        ? 'Você será avisado sobre o que precisa de atenção.'
                        : 'Ative para acompanhar estoque e listas pendentes.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: foreground,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
