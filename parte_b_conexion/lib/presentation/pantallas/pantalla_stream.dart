import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';
import '../../domain/usecases/observar_conexion.dart';
import '../estado/conexion_cubit.dart';

class PantallaStream extends StatefulWidget {
  const PantallaStream({
    super.key,
    required this.consultarConexion,
    required this.observarConexion,
  });

  final ConsultarConexion consultarConexion;
  final ObservarConexion observarConexion;

  @override
  State<PantallaStream> createState() => _PantallaStreamState();
}

class _PantallaStreamState extends State<PantallaStream>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int _cambios = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (_) => ConexionCubit(
        widget.consultarConexion,
        widget.observarConexion,
        onCambio: () {
          if (mounted) setState(() => _cambios++);
        },
      )..iniciar(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Conexion en tiempo real')),
        body: BlocBuilder<ConexionCubit, EstadoConexion>(
          builder: (context, estado) {
            final (texto, icono) = switch (estado) {
              EstadoConexion.wifi => ('Wi-Fi', Icons.wifi),
              EstadoConexion.datosMoviles => (
                'Datos moviles',
                Icons.signal_cellular_alt,
              ),
              EstadoConexion.otro => ('Otra conexion', Icons.network_check),
              EstadoConexion.sinConexion => ('Sin conexion', Icons.wifi_off),
            };
            final color = estado == EstadoConexion.sinConexion
                ? Colors.red
                : Colors.green;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icono, size: 80, color: color),
                    const SizedBox(height: 16),
                    Text(
                      texto,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Cambios recibidos: $_cambios'),
                    const SizedBox(height: 12),
                    const Text(
                      'El estado se actualiza automaticamente.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
