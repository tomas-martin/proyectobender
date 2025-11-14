import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../vista_modelos/navigation_viewmodel.dart';
import '../vista_modelos/finanzas_vm.dart';
import '../widgets/grafico_ingresos.dart';

class FinanzasVista extends StatelessWidget {
  const FinanzasVista({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<FinanzasViewModel>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Finanzas'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const GraficoIngresos(),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resumen financiero',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.amberAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '💰 Total anual: \$${vm.totalAnual.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '📅 Promedio mensual: \$${vm.promedioMensual.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
