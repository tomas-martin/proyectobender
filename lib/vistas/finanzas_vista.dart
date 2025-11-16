import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gráfico de ingresos
            const GraficoIngresos(),
            const SizedBox(height: 24),

            // Resumen financiero principal
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.amber.withOpacity(0.2),
                    Colors.amber.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.trending_up, color: Colors.amber, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        'Resumen Anual ${DateTime.now().year}',
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildStatRow(
                    'Total recaudado',
                    '\$${vm.totalAnual.toStringAsFixed(0)}',
                    Colors.greenAccent,
                    Icons.attach_money,
                  ),
                  const SizedBox(height: 12),

                  _buildStatRow(
                    'Promedio mensual',
                    '\$${vm.promedioMensual.toStringAsFixed(0)}',
                    Colors.blueAccent,
                    Icons.calendar_month,
                  ),
                  const SizedBox(height: 12),

                  _buildStatRow(
                    'Mejor mes',
                    vm.mejorMes,
                    Colors.purpleAccent,
                    Icons.star,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Estadísticas de pagos
            const Text(
              'Estado de Pagos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Pagados',
                    vm.cantidadPagados.toString(),
                    Colors.green,
                    Icons.check_circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Pendientes',
                    vm.cantidadPendientes.toString(),
                    Colors.orange,
                    Icons.pending,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Morosos',
                    vm.cantidadMorosos.toString(),
                    Colors.red,
                    Icons.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Proyecciones
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.insights, color: Colors.cyan, size: 24),
                      const SizedBox(width: 12),
                      const Text(
                        'Proyecciones',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildStatRow(
                    'Ingresos por cobrar (pendientes)',
                    '\$${vm.totalPendiente.toStringAsFixed(0)}',
                    Colors.orange,
                    Icons.schedule,
                  ),
                  const SizedBox(height: 12),

                  _buildStatRow(
                    'Deuda acumulada (morosos)',
                    '\$${vm.totalMoroso.toStringAsFixed(0)}',
                    Colors.red,
                    Icons.warning_amber,
                  ),
                  const SizedBox(height: 12),

                  _buildStatRow(
                    'Proyección fin de año',
                    '\$${vm.proyeccionAnual.toStringAsFixed(0)}',
                    Colors.purpleAccent,
                    Icons.analytics,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Desglose mensual
            const Text(
              'Desglose Mensual',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            _buildDesgloseMensual(vm),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDesgloseMensual(FinanzasViewModel vm) {
    const meses = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 12,
        separatorBuilder: (_, __) => const Divider(color: Colors.white12, height: 1),
        itemBuilder: (context, i) {
          final ingreso = vm.mensual[i];
          final mesActual = DateTime.now().month - 1;
          final esMesActual = i == mesActual;

          return ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: esMesActual
                    ? Colors.amber.withOpacity(0.2)
                    : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '${i + 1}',
                  style: TextStyle(
                    color: esMesActual ? Colors.amber : Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: Text(
              meses[i],
              style: TextStyle(
                color: esMesActual ? Colors.amber : Colors.white,
                fontWeight: esMesActual ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            trailing: Text(
              '\$${ingreso.toStringAsFixed(0)}',
              style: TextStyle(
                color: ingreso > 0 ? Colors.greenAccent : Colors.white38,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}