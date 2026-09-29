import 'package:connectivity_plus/connectivity_plus.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/repositories/conexion_repository.dart';

class ConexionPlusRepository implements ConexionRepository {
  @override
  Future<EstadoConexion> consultarAhora() async {
    final resultados = await Connectivity().checkConnectivity();
    return _traducir(resultados);
  }

  @override
  Stream<EstadoConexion> observarCambios() {
    return Connectivity().onConnectivityChanged.map(_traducir);
  }

  EstadoConexion _traducir(List<ConnectivityResult> resultados) {
    if (resultados.contains(ConnectivityResult.wifi)) {
      return EstadoConexion.wifi;
    }
    if (resultados.contains(ConnectivityResult.mobile)) {
      return EstadoConexion.datosMoviles;
    }
    return EstadoConexion.sinConexion;
  }
}
