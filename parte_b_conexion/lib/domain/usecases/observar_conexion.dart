import '../entities/estado_conexion.dart';
import '../repositories/conexion_repository.dart';

class ObservarConexion {
  final ConexionRepository _repository;

  ObservarConexion(this._repository);

  Stream<EstadoConexion> call() => _repository.observarCambios();
}
