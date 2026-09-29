import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parte_b_conexion/domain/entities/estado_conexion.dart';
import 'package:parte_b_conexion/domain/repositories/conexion_repository.dart';
import 'package:parte_b_conexion/domain/usecases/consultar_conexion.dart';
import 'package:parte_b_conexion/domain/usecases/observar_conexion.dart';
import 'package:parte_b_conexion/presentation/estado/conexion_cubit.dart';
import 'package:parte_b_conexion/presentation/pantallas/pantalla_stream.dart';

class _Repository implements ConexionRepository {
  final eventos = StreamController<EstadoConexion>();
  final inicial = Completer<EstadoConexion>();

  @override
  Future<EstadoConexion> consultarAhora() => inicial.future;

  @override
  Stream<EstadoConexion> observarCambios() => eventos.stream;
}

void main() {
  test(
    'Consulta primero, evita suscripciones duplicadas y cancela al cerrar',
    () async {
      final repository = _Repository();
      final cubit = ConexionCubit(
        ConsultarConexion(repository),
        ObservarConexion(repository),
      );
      expect(cubit.state, EstadoConexion.otro);
      final inicio = cubit.iniciar();
      expect(repository.eventos.hasListener, isFalse);
      repository.inicial.complete(EstadoConexion.wifi);
      await inicio;
      expect(cubit.state, EstadoConexion.wifi);
      expect(repository.eventos.hasListener, isTrue);
      await cubit.iniciar();
      await cubit.close();
      expect(repository.eventos.hasListener, isFalse);
      await repository.eventos.close();
    },
  );

  test(
    'Cerrar durante la consulta inicial evita suscribirse despues',
    () async {
      final repository = _Repository();
      final cubit = ConexionCubit(
        ConsultarConexion(repository),
        ObservarConexion(repository),
      );
      final inicio = cubit.iniciar();
      await cubit.close();
      repository.inicial.complete(EstadoConexion.wifi);
      await inicio;
      expect(repository.eventos.hasListener, isFalse);
      repository.eventos.stream.listen((_) {});
      await repository.eventos.close();
    },
  );

  testWidgets(
    'Actualiza el estado y cuenta cada evento sin contar la consulta',
    (tester) async {
      final repository = _Repository();
      repository.inicial.complete(EstadoConexion.wifi);
      await tester.pumpWidget(
        MaterialApp(
          home: PantallaStream(
            consultarConexion: ConsultarConexion(repository),
            observarConexion: ObservarConexion(repository),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Wi-Fi'), findsOneWidget);
      expect(find.text('Cambios recibidos: 0'), findsOneWidget);
      repository.eventos.add(EstadoConexion.sinConexion);
      await tester.pumpAndSettle();
      expect(find.text('Sin conexion'), findsOneWidget);
      expect(find.text('Cambios recibidos: 1'), findsOneWidget);
      repository.eventos.add(EstadoConexion.sinConexion);
      await tester.pumpAndSettle();
      expect(find.text('Cambios recibidos: 2'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
      expect(repository.eventos.hasListener, isFalse);
      await tester.runAsync(() => repository.eventos.close());
    },
  );
}
