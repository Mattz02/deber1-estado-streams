import '../entities/estado_conexion.dart';
import '../repositories/conexion_repository.dart';

class ConsultarConexion {
  final ConexionRepository _repository;

  ConsultarConexion(this._repository);

  Future<EstadoConexion> call() => _repository.consultarAhora();
}
