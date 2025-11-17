import 'package:flutter/material.dart';
import 'package:probando_app_bender_v0/vista_modelos/avisos_vm.dart';
import 'package:probando_app_bender_v0/vista_modelos/errores_vm.dart';
import 'package:probando_app_bender_v0/vista_modelos/propietarios_vm.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'theme/tema_bender.dart';
import 'vista_modelos/navigation_viewmodel.dart';
import 'vista_modelos/propiedades_vm.dart';
import 'vista_modelos/pagos_vm.dart';
import 'vista_modelos/finanzas_vm.dart';
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
        ChangeNotifierProvider(create: (_) => NavigationViewModel()),
        ChangeNotifierProvider(create: (_) => PropiedadesViewModel()),
        ChangeNotifierProvider(create: (_) => FinanzasViewModel()),
        ChangeNotifierProvider(create: (_) => PropietariosViewModel()),
        ChangeNotifierProvider(create: (_) => AvisosViewModel()),
        ChangeNotifierProvider(create: (_) => ErroresViewModel()),
        // ✅ PagosViewModel debe ir después de FinanzasViewModel
        ChangeNotifierProxyProvider<FinanzasViewModel, PagosViewModel>(
          create: (context) {
            final pagosVM = PagosViewModel();
            final finanzasVM = Provider.of<FinanzasViewModel>(context, listen: false);

            // ✅ Conectar PagosViewModel con FinanzasViewModel
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