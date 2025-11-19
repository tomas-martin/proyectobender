import 'package:flutter/material.dart';
import '../vista_modelos/navigation_viewmodel.dart';

class BarraInferior extends StatelessWidget {
  final NavigationViewModel viewModel;
  const BarraInferior({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF1C1C1C),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.amber,
      unselectedItemColor: Colors.white,
      currentIndex: viewModel.indiceActual.clamp(0, 4),
      onTap: (index) {
        // ✅ Verificar si podemos hacer pop (si hay vistas apiladas)
        if (Navigator.of(context).canPop()) {
          // Estamos en una vista secundaria (Reportes, Recordatorios, etc.)
          Navigator.of(context).pop();
        }

        // Cambiar el índice de navegación
        viewModel.cambiarIndice(index);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.home_work_outlined), label: 'Propiedades'),
        BottomNavigationBarItem(icon: Icon(Icons.payment_outlined), label: 'Pagos'),
        BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label: 'Finanzas'),
        BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Propietarios'),
      ],
    );
  }
}