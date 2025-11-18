import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../vista_modelos/finanzas_vm.dart';
import '../vista_modelos/navigation_viewmodel.dart';
import '../widgets/grafico_ingresos.dart';
import '../widgets/boton_accion.dart';
import 'calculadora_apuestas_vista.dart';

class TableroVista extends StatelessWidget {
  const TableroVista({super.key});

  @override
  Widget build(BuildContext context) {
    final finVM = Provider.of<FinanzasViewModel>(context);
    final nav = Provider.of<NavigationViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tablero de Bender'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¡Hola, Bender!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              Text(
                'Tu imperio inmobiliario al alcance de un toque',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 18),

              // === TARJETA CON GRÁFICO ===
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.amber.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.show_chart, color: Colors.amber, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'Ingresos - últimos 12 meses',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const GraficoIngresos(),
                    const SizedBox(height: 16),

                    // Estadísticas
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStat(
                            'Total Año',
                            '\$${finVM.totalAnual.toStringAsFixed(0)}',
                            Colors.greenAccent,
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.white12,
                          ),
                          _buildStat(
                            'Promedio',
                            '\$${finVM.promedioMensual.toStringAsFixed(0)}',
                            Colors.blueAccent,
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.white12,
                          ),
                          _buildStat(
                            'Mejor Mes',
                            finVM.mejorMes,
                            Colors.amber,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // === GRID DE ACCIONES (2x2) ===
              const Text(
                'Acciones Rápidas',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  BotonAccion(
                    icono: Icons.home_work_outlined,
                    texto: 'Propiedades',
                    color: Theme.of(context).colorScheme.primary,
                    onTap: () => nav.cambiarIndice(1),
                  ),
                  BotonAccion(
                    icono: Icons.payment,
                    texto: 'Pagos',
                    color: Theme.of(context).colorScheme.secondary,
                    onTap: () => nav.cambiarIndice(2),
                  ),
                  BotonAccion(
                    icono: Icons.show_chart,
                    texto: 'Finanzas',
                    color: Colors.orangeAccent,
                    onTap: () => nav.cambiarIndice(3),
                  ),
                  BotonAccion(
                    icono: Icons.people,
                    texto: 'Propietarios',
                    color: Colors.purpleAccent,
                    onTap: () => nav.cambiarIndice(4),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // === CALCULADORA DE APUESTAS ===
              const Text(
                'Herramientas',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              Card(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CalculadoraApuestasVista(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.calculate,
                            color: Colors.greenAccent,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Calculadora de Apuestas',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Calcula ganancias y cuotas',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white38,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}