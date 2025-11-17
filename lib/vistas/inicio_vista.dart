import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../vista_modelos/navigation_viewmodel.dart';
import '../widgets/barra_inferior.dart';
import 'tablero_vista.dart';
import 'propiedades_vista.dart';
import 'pagos_vista.dart';
import 'finanzas_vista.dart';
import 'propietarios_vista.dart'; // ✅ NUEVO

class InicioVista extends StatefulWidget {
  const InicioVista({super.key});

  @override
  State<InicioVista> createState() => _InicioVistaState();
}

class _InicioVistaState extends State<InicioVista> {
  bool _mostrarPantallaInicio = true;

  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavigationViewModel>(context);

    // ✅ SOLO 5 PANTALLAS: Tablero, Propiedades, Pagos, Finanzas, Propietarios
    final paginas = const [
      TableroVista(),
      PropiedadesVista(),
      PagosVista(),
      FinanzasVista(),
      PropietariosVista(), // ✅ NUEVO
    ];

    return WillPopScope(
      onWillPop: () async {
        nav.cambiarIndice(0);
        setState(() {
          _mostrarPantallaInicio = false;
        });
        return false;
      },
      child: Scaffold(
        appBar: _mostrarPantallaInicio
            ? null
            : AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              nav.cambiarIndice(0);
            },
          ),
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _mostrarPantallaInicio
              ? _buildPantallaInicio(context)
              : IndexedStack(index: nav.indiceActual, children: paginas),
        ),
        bottomNavigationBar:
        _mostrarPantallaInicio ? null : BarraInferior(viewModel: nav),
      ),
    );
  }

  Widget _buildPantallaInicio(BuildContext context) {
    return Container(
      key: const ValueKey('inicio'),
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/bender.png',
            width: 200,
            height: 200,
            errorBuilder: (context, error, stack) => const Icon(
              Icons.android,
              color: Colors.amber,
              size: 200,
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Bienvenido a Bender Inmobiliaria',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              padding:
              const EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              setState(() {
                _mostrarPantallaInicio = false;
              });
            },
            child: const Text(
              'Entrar',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}