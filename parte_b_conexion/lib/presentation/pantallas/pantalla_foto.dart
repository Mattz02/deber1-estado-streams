import 'package:flutter/material.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';

class PantallaFoto extends StatefulWidget {
  const PantallaFoto({super.key, required this.consultarConexion});

  final ConsultarConexion consultarConexion;

  @override
  State<PantallaFoto> createState() => _PantallaFotoState();
}

class _PantallaFotoState extends State<PantallaFoto>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  EstadoConexion? _estado;
  DateTime? _horaConsulta;
  bool _consultando = false;
  String? _error;

  Future<void> _consultar() async {
    setState(() {
      _consultando = true;
      _error = null;
    });

    final horaConsulta = DateTime.now();
    try {
      final estado = await widget.consultarConexion();
      if (!mounted) return;

      setState(() {
        _estado = estado;
        _horaConsulta = horaConsulta;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'No se pudo consultar la conexion. Intenta de nuevo.';
      });
    } finally {
      if (mounted) {
        setState(() => _consultando = false);
      }
    }
  }

  String _formatearHora(DateTime hora) {
    final horas = hora.hour.toString().padLeft(2, '0');
    final minutos = hora.minute.toString().padLeft(2, '0');
    final segundos = hora.second.toString().padLeft(2, '0');
    return '$horas:$minutos:$segundos';
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final (texto, icono) = switch (_estado) {
      EstadoConexion.wifi => ('Wi-Fi', Icons.wifi),
      EstadoConexion.datosMoviles => (
        'Datos moviles',
        Icons.signal_cellular_alt,
      ),
      EstadoConexion.otro => ('Otra conexion', Icons.network_check),
      EstadoConexion.sinConexion => ('Sin conexion', Icons.wifi_off),
      null => ('Sin consulta', Icons.help_outline),
    };
    final color = _estado == null
        ? Colors.grey
        : _estado == EstadoConexion.sinConexion
        ? Colors.red
        : Colors.green;

    return Scaffold(
      appBar: AppBar(title: const Text('Consulta de conexion')),
      body: Center(
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
              if (_horaConsulta != null) ...[
                const SizedBox(height: 12),
                Text('Hora de consulta: ${_formatearHora(_horaConsulta!)}'),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _consultando ? null : _consultar,
                child: const Text('Consultar ahora'),
              ),
              if (_consultando) ...[
                const SizedBox(height: 16),
                const CircularProgressIndicator(),
              ],
              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 24),
              const Text(
                'El resultado solo se actualiza al pulsar Consultar ahora.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
