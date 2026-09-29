import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';
import '../../domain/usecases/observar_conexion.dart';

class ConexionCubit extends Cubit<EstadoConexion> {
  ConexionCubit(
    this._consultarConexion,
    this._observarConexion, {
    this.onCambio,
  }) : super(EstadoConexion.otro);

  final ConsultarConexion _consultarConexion;
  final ObservarConexion _observarConexion;
  final void Function()? onCambio;
  StreamSubscription<EstadoConexion>? _subscription;
  bool _iniciado = false;
  bool _cerrando = false;

  Future<void> iniciar() async {
    if (_iniciado || _cerrando || isClosed) return;
    _iniciado = true;

    try {
      final estado = await _consultarConexion();
      if (_cerrando || isClosed) return;
      emit(estado);
    } catch (error, stackTrace) {
      if (_cerrando || isClosed) return;
      addError(error, stackTrace);
    }

    if (_cerrando || isClosed) return;
    _subscription = _observarConexion().listen(
      (estado) {
        if (_cerrando || isClosed) return;
        emit(estado);
        // Cuenta cada evento, incluso si Cubit omite un estado repetido.
        onCambio?.call();
      },
      onError: (Object error, StackTrace stackTrace) {
        if (!_cerrando && !isClosed) addError(error, stackTrace);
      },
    );
  }

  @override
  Future<void> close() async {
    _cerrando = true;
    await _subscription?.cancel();
    await super.close();
  }
}
