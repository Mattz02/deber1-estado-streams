import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../estado/contador_provider.dart';

class PantallaControl extends ConsumerWidget {
  const PantallaControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contador = ref.watch(contadorProvider);
    ref.listen(contadorProvider, (anterior, siguiente) {
      if (siguiente.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo guardar el contador.')),
        );
      }
    });
    return PopScope<void>(
      canPop: !contador.cargando,
      child: Scaffold(
        appBar: AppBar(title: const Text('Control')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Contador: ${contador.valor}',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: contador.cargando
                        ? null
                        : () =>
                              ref.read(contadorProvider.notifier).incrementar(),
                    child: const Text('+1'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: contador.cargando
                        ? null
                        : () =>
                              ref.read(contadorProvider.notifier).decrementar(),
                    child: const Text('-1'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: contador.cargando
                    ? null
                    : () => Navigator.pop(context),
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
