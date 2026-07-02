import 'package:flutter/material.dart';

class BootstrapPage extends StatelessWidget {
  const BootstrapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('CompraCerta')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.shopping_cart_checkout_outlined,
                  color: colorScheme.primary,
                  size: 40,
                ),
                const SizedBox(height: 24),
                Text('Ambiente preparado', style: textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  'A base profissional do CompraCerta esta pronta para receber os modulos de negocio.',
                  style: textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
