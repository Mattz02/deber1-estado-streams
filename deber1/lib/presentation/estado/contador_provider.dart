import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/contador_prefs_repository.dart';
import '../../domain/repositories/contador_repository.dart';
import '../../domain/usecases/decrementar.dart';
import '../../domain/usecases/incrementar.dart';
import '../../domain/usecases/obtener_contador.dart';

final contadorRepositoryProvider = Provider<ContadorRepository>(
  (ref) => ContadorPrefsRepository(),
);

final obtenerContadorProvider = Provider<ObtenerContador>(
  (ref) => ObtenerContador(ref.watch(contadorRepositoryProvider)),
);

final incrementarProvider = Provider<Incrementar>(
  (ref) => Incrementar(ref.watch(contadorRepositoryProvider)),
);

final decrementarProvider = Provider<Decrementar>(
  (ref) => Decrementar(ref.watch(contadorRepositoryProvider)),
);

final contadorProvider = NotifierProvider<ContadorNotifier, EstadoContador>(
  ContadorNotifier.new,
);

class EstadoContador {
  const EstadoContador({this.valor = 0, this.cargando = false, this.error});

  final int valor;
  final bool cargando;
  final Object? error;
}

class ContadorNotifier extends Notifier<EstadoContador> {
  bool _ejecutando = false;

  @override
  EstadoContador build() {
    // Carga inicial una vez que Riverpod haya creado el estado.
    Future.microtask(() {
      if (ref.mounted) cargar();
    });
    return const EstadoContador(cargando: true);
  }

  Future<void> cargar() => _ejecutar(ref.read(obtenerContadorProvider).call);

  Future<void> incrementar() => _ejecutar(ref.read(incrementarProvider).call);

  Future<void> decrementar() => _ejecutar(ref.read(decrementarProvider).call);

  Future<void> _ejecutar(Future<int> Function() accion) async {
    // Los casos de uso leen y escriben: no deben ejecutarse simultáneamente.
    if (_ejecutando) return;
    _ejecutando = true;
    state = EstadoContador(valor: state.valor, cargando: true);
    try {
      final valor = await accion();
      if (ref.mounted) state = EstadoContador(valor: valor);
    } catch (error) {
      if (ref.mounted) {
        state = EstadoContador(valor: state.valor, error: error);
      }
    } finally {
      _ejecutando = false;
    }
  }
}
