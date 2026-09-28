import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../estado/contador_cubit.dart';

class PantallaControl extends StatefulWidget {
  const PantallaControl({super.key});

  @override
  State<PantallaControl> createState() => _PantallaControlState();
}

class _PantallaControlState extends State<PantallaControl> {
  bool _guardando = false;

  Future<void> _cambiarContador(Future<void> Function() accion) async {
    if (_guardando) return;
    setState(() => _guardando = true);
    try {
      await accion();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo guardar el contador.')),
      );
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<void>(
      canPop: !_guardando,
      child: Scaffold(
        appBar: AppBar(title: const Text('Control')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<ContadorCubit, int>(
                builder: (context, contador) => Text(
                  'Contador: $contador',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _guardando
                        ? null
                        : () => _cambiarContador(
                            context.read<ContadorCubit>().incrementar,
                          ),
                    child: const Text('+1'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _guardando
                        ? null
                        : () => _cambiarContador(
                            context.read<ContadorCubit>().decrementar,
                          ),
                    child: const Text('-1'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _guardando ? null : () => Navigator.pop(context),
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
