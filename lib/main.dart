import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart'; // ⬅️ IMPORTANTE

import 'theme/tema_bender.dart';
import 'vista_modelos/navigation_viewmodel.dart';
import 'vista_modelos/propiedades_vm.dart';
import 'vista_modelos/pagos_vm.dart';
import 'vista_modelos/finanzas_vm.dart';
import 'vistas/inicio_vista.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();   // ⬅️ Necesario antes de inicializar Firebase
  await Firebase.initializeApp();              // ⬅️ Inicializa Firebase

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
        ChangeNotifierProvider(create: (_) => PagosViewModel()),
        ChangeNotifierProvider(create: (_) => FinanzasViewModel()),
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
