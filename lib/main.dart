import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'theme/tema_bender.dart';
import 'vista_modelos/navigation_viewmodel.dart';
import 'vista_modelos/propiedades_vm.dart';
import 'vista_modelos/pagos_vm.dart';
import 'vista_modelos/finanzas_vm.dart';
import 'vista_modelos/propietarios_vm.dart';
import 'vista_modelos/avisos_vm.dart';
import 'vista_modelos/errores_vm.dart';
import 'vistas/inicio_vista.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Navegación
        ChangeNotifierProvider(create: (_) => NavigationViewModel()),

        // Propiedades y Propietarios
        ChangeNotifierProvider(create: (_) => PropiedadesViewModel()),
        ChangeNotifierProvider(create: (_) => PropietariosViewModel()),

        // Finanzas
        ChangeNotifierProvider(create: (_) => FinanzasViewModel()),

        // Pagos - conectado con Finanzas
        ChangeNotifierProxyProvider<FinanzasViewModel, PagosViewModel>(
          create: (context) {
            final pagosVM = PagosViewModel();
            final finanzasVM = Provider.of<FinanzasViewModel>(context, listen: false);

            // Conectar PagosViewModel con FinanzasViewModel
            pagosVM.onPagosActualizados = (pagos) {
              finanzasVM.actualizarConPagos(pagos);
            };

            return pagosVM;
          },
          update: (context, finanzasVM, pagosVM) {
            // Mantener la conexión actualizada
            pagosVM?.onPagosActualizados = (pagos) {
              finanzasVM.actualizarConPagos(pagos);
            };
            return pagosVM!;
          },
        ),

        // Avisos y Errores
        ChangeNotifierProvider(create: (_) => AvisosViewModel()),
        ChangeNotifierProvider(create: (_) => ErroresViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Inmobiliaria Bender',
        theme: TemaBender.tema(),
        home: const InicioVista(),
      ),
    );
  }
}