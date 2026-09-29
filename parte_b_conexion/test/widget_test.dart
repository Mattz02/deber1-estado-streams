import 'package:flutter_test/flutter_test.dart';
import 'package:parte_b_conexion/domain/entities/estado_conexion.dart';
import 'package:parte_b_conexion/domain/repositories/conexion_repository.dart';
import 'package:parte_b_conexion/domain/usecases/consultar_conexion.dart';
import 'package:parte_b_conexion/main.dart';
import 'package:parte_b_conexion/domain/usecases/observar_conexion.dart';

class _ConexionRepositoryFake implements ConexionRepository {
  int consultas = 0;

  @override
  Future<EstadoConexion> consultarAhora() async {
    consultas++;
    return EstadoConexion.wifi;
  }

  @override
  Stream<EstadoConexion> observarCambios() {
    throw StateError('Esta pantalla no debe observar cambios.');
  }
}

void main() {
  testWidgets('La app consulta la conexion solo al pulsar el boton', (
    tester,
  ) async {
    final repository = _ConexionRepositoryFake();
    await tester.pumpWidget(
      MyApp(
        consultarConexion: ConsultarConexion(repository),
        observarConexion: ObservarConexion(repository),
      ),
    );

    expect(find.text('Sin consulta'), findsOneWidget);
    expect(repository.consultas, 0);

    await tester.tap(find.text('Consultar ahora'));
    await tester.pumpAndSettle();

    expect(find.text('Wi-Fi'), findsOneWidget);
    expect(repository.consultas, 1);
    expect(
      find.textContaining(RegExp(r'Hora de consulta: \d{2}:\d{2}:\d{2}')),
      findsOneWidget,
    );
  });
}
