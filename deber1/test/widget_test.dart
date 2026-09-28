import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:deber1/domain/repositories/contador_repository.dart';
import 'package:deber1/domain/usecases/decrementar.dart';
import 'package:deber1/domain/usecases/incrementar.dart';
import 'package:deber1/domain/usecases/obtener_contador.dart';
import 'package:deber1/main.dart';

class _RepositorioEnMemoria implements ContadorRepository {
  _RepositorioEnMemoria(this.valor);

  int valor;

  @override
  Future<int> leer() async => valor;

  @override
  Future<void> guardar(int nuevoValor) async {
    valor = nuevoValor;
  }
}

void main() {
  Future<void> abrirApp(
    WidgetTester tester,
    ContadorRepository repository,
  ) async {
    await tester.pumpWidget(
      MyApp(
        obtenerContador: ObtenerContador(repository),
        incrementar: Incrementar(repository),
        decrementar: Decrementar(repository),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Carga, modifica y devuelve el contador al visor', (
    tester,
  ) async {
    final repository = _RepositorioEnMemoria(7);
    await abrirApp(tester, repository);
    expect(find.text('Contador: 7'), findsOneWidget);

    await tester.tap(find.text('Ir a Control'));
    await tester.pumpAndSettle();
    expect(find.text('Contador: 7'), findsOneWidget);

    await tester.tap(find.text('+1'));
    await tester.pumpAndSettle();
    expect(find.text('Contador: 8'), findsOneWidget);
    expect(repository.valor, 8);

    await tester.tap(find.text('-1'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('-1'));
    await tester.pumpAndSettle();
    expect(find.text('Contador: 6'), findsOneWidget);
    expect(repository.valor, 6);

    await tester.tap(find.text('Volver'));
    await tester.pumpAndSettle();
    expect(find.text('Visor'), findsOneWidget);
    expect(find.text('Contador: 6'), findsOneWidget);

    await tester.tap(find.text('Ir a Control'));
    await tester.pumpAndSettle();
    expect(find.text('Contador: 6'), findsOneWidget);
  });

  testWidgets('Actualiza el visor al regresar con el botón del sistema', (
    tester,
  ) async {
    final repository = _RepositorioEnMemoria(0);
    await abrirApp(tester, repository);
    await tester.tap(find.text('Ir a Control'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('-1'));
    await tester.pumpAndSettle();
    expect(find.text('Contador: -1'), findsOneWidget);

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    await navigator.maybePop();
    await tester.pumpAndSettle();
    expect(find.text('Visor'), findsOneWidget);
    expect(find.text('Contador: -1'), findsOneWidget);
  });
}
