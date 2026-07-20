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
      appBar: AppBar(title: const Text('Notificacoes')),
      body: preferenciasState.when(
        data: (preferencias) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Ativar notificacoes'),
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
                    title: const Text('Estoque baixo'),
                    subtitle: const Text(
                      'Avisar quando um produto precisar de reposicao.',
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
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.notifications_active_outlined),
              label: const Text('Atualizar lembretes agora'),
            ),
            const SizedBox(height: 12),
            Text(
              'Os lembretes sao calculados no aparelho e nenhum dado e enviado pela internet.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 40),
                const SizedBox(height: 12),
                const Text('Nao foi possivel carregar as preferencias.'),
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

  Future<void> _atualizar(
    PreferenciasNotificacaoEntity preferencias, {
    bool solicitarPermissao = false,
  }) async {
    await ref.read(preferenciasNotificacaoProvider.notifier).salvar(preferencias);
    if (!mounted) return;

    final salvamento = ref.read(preferenciasNotificacaoProvider);
    if (salvamento.hasError) {
      _mostrarMensagem('Nao foi possivel salvar as preferencias.');
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
        _mostrarMensagem('Nao foi possivel atualizar os lembretes.');
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
