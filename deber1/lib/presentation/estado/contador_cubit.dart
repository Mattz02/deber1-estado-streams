import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/decrementar.dart';
import '../../domain/usecases/incrementar.dart';
import '../../domain/usecases/obtener_contador.dart';

class ContadorCubit extends Cubit<int> {
  ContadorCubit(this._obtenerContador, this._incrementar, this._decrementar)
    : super(0);

  final ObtenerContador _obtenerContador;
  final Incrementar _incrementar;
  final Decrementar _decrementar;

  Future<void> cargar() async {
    final valor = await _obtenerContador();
    if (!isClosed) emit(valor);
  }

  Future<void> incrementar() async {
    final valor = await _incrementar();
    if (!isClosed) emit(valor);
  }

  Future<void> decrementar() async {
    final valor = await _decrementar();
    if (!isClosed) emit(valor);
  }
}
