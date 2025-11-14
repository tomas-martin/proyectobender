import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../vista_modelos/finanzas_vm.dart';
import '../vista_modelos/navigation_viewmodel.dart';
import '../widgets/grafico_ingresos.dart';
import '../widgets/boton_accion.dart';
import '../widgets/tarjeta_propiedad.dart';

class TableroVista extends StatelessWidget {
  const TableroVista({super.key});

  @override
  Widget build(BuildContext context) {
    // Ahora sí escucha cambios en finanzas
    final finVM = Provider.of<FinanzasViewModel>(context);

    // La navegación no necesita escuchar cambios
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
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ingresos - últimos 12 meses',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const GraficoIngresos(),
                    const SizedBox(height: 8),

                    // Valores dependientes de FinanzasViewModel (escuchando cambios)
                    Text(
                      'Total año: \$${finVM.totalAnual.toStringAsFixed(0)}',
                      style: const TextStyle(color: Colors.greenAccent),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Promedio mensual: \$${finVM.promedioMensual.toStringAsFixed(0)}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // === GRID DE ACCIONES ===
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
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
                    icono: Icons.campaign_outlined,
                    texto: 'Avisos',
                    color: Colors.lightBlueAccent,
                    onTap: () => nav.cambiarIndice(4),
                  ),
                  BotonAccion(
                    icono: Icons.bug_report,
                    texto: 'Errores',
                    color: Colors.redAccent,
                    onTap: () => nav.cambiarIndice(5),
                  ),
                  BotonAccion(
                    icono: Icons.more_horiz,
                    texto: 'Ver más',
                    color: Colors.purpleAccent,
                    onTap: () => nav.cambiarIndice(6),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // === SECCIÓN PREMIUM ===
              const Text(
                'Funciones Premium',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              TarjetaPropiedad(
                titulo: 'Análisis avanzado',
                descripcion: 'Reportes mensuales y predicciones.',
                icono: Icons.query_stats,
                color: Colors.greenAccent,
              ),
              const SizedBox(height: 10),

              TarjetaPropiedad(
                titulo: 'Cobro automático',
                descripcion: 'Envía recordatorios y cobra automáticamente.',
                icono: Icons.autorenew,
                color: Colors.yellowAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
