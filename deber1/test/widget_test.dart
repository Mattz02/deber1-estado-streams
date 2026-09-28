import 'package:deber1/main.dart';
import 'package:deber1/presentation/estado/contador_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Carga, guarda y comparte el contador al navegar', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'contador': 7});
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();
    expect(find.text('Contador: 7'), findsOneWidget);

    await tester.tap(find.text('Ir a Control'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('+1'));
    await tester.pumpAndSettle();
    expect(find.text('Contador: 8'), findsOneWidget);
    await tester.tap(find.text('Volver'));
    await tester.pumpAndSettle();
    expect(find.text('Contador: 8'), findsOneWidget);

    await tester.tap(find.text('Ir a Control'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('-1'));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Contador: 7'), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getInt('contador'), 7);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(MaterialApp)),
    );
    await prefs.setInt('contador', 20);
    await container.read(contadorProvider.notifier).cargar();
    await tester.pumpAndSettle();
    expect(find.text('Contador: 20'), findsOneWidget);
  });
}
