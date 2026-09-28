import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../estado/contador_cubit.dart';
import 'pantalla_control.dart';

class PantallaVisor extends StatefulWidget {
  const PantallaVisor({super.key});

  @override
  State<PantallaVisor> createState() => _PantallaVisorState();
}

class _PantallaVisorState extends State<PantallaVisor> {
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarContador();
  }

  Future<void> _cargarContador() async {
    try {
      await context.read<ContadorCubit>().cargar();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo cargar el contador.')),
      );
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  void _irAControl() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const PantallaControl()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visor')),
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
            if (_cargando) const CircularProgressIndicator(),
            ElevatedButton(
              onPressed: _cargando ? null : _irAControl,
              child: const Text('Ir a Control'),
            ),
          ],
        ),
      ),
    );
  }
}
