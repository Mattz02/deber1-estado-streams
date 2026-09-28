import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repositories/contador_prefs_repository.dart';
import 'domain/usecases/decrementar.dart';
import 'domain/usecases/incrementar.dart';
import 'domain/usecases/obtener_contador.dart';
import 'presentation/estado/contador_cubit.dart';
import 'presentation/pantallas/pantalla_visor.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = ContadorBlocObserver();
  runApp(const MyApp());
}

class ContadorBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (bloc is ContadorCubit) {
      debugPrint(
        'ContadorCubit: ${change.currentState} -> ${change.nextState}',
      );
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final repository = ContadorPrefsRepository();
        return ContadorCubit(
          ObtenerContador(repository),
          Incrementar(repository),
          Decrementar(repository),
        );
      },
      child: MaterialApp(
        title: 'Contador con Bloc',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const PantallaVisor(),
      ),
    );
  }
}
