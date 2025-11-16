import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../vista_modelos/pagos_vm.dart';
import 'agregar_pago_vista.dart';

class PagosVista extends StatelessWidget {
  const PagosVista({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PagosViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pagos (${vm.pagos.length})'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              vm.escucharPagos();
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: vm.cargando
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.amber),
            SizedBox(height: 16),
            Text(
              'Cargando pagos...',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      )
          : vm.error != null
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.redAccent,
                size: 60,
              ),
              const SizedBox(height: 16),
              Text(
                vm.error!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  vm.escucharPagos();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      )
          : vm.pagos.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.payment,
              size: 80,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            const Text(
              "No hay pagos registrados",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Toca el botón + para agregar",
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
          : Column(
        children: [
          // Resumen de pagos
          _buildResumen(vm),

          // Lista de pagos
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(
                left: 12,
                right: 12,
                top: 12,
                bottom: 80,
              ),
              itemCount: vm.pagos.length,
              itemBuilder: (context, i) {
                final p = vm.pagos[i];
                return Card(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    // ✅ NUEVO: Al tocar muestra opciones
                    onTap: () => _mostrarOpcionesPago(context, p),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: _getEstadoColor(p.estado).withOpacity(0.2),
                            child: Icon(
                              _getEstadoIcon(p.estado),
                              color: _getEstadoColor(p.estado),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.propiedadTitulo,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  p.inquilinoNombre,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Text(
                                      '\$${p.monto.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getEstadoColor(p.estado).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        p.estado.toUpperCase(),
                                        style: TextStyle(
                                          color: _getEstadoColor(p.estado),
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${p.fecha.day}/${p.fecha.month}/${p.fecha.year}',
                                      style: const TextStyle(
                                        color: Colors.white38,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // ✅ NUEVO: Indicador visual de que es clickeable
                          Icon(
                            Icons.more_vert,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AgregarPagoVista(),
            ),
          );
        },
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text('Registrar Pago'),
      ),
    );
  }

  // ✅ NUEVO: Mostrar opciones al tocar un pago
  void _mostrarOpcionesPago(BuildContext context, pago) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pago.propiedadTitulo,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${pago.monto.toStringAsFixed(0)} • ${pago.inquilinoNombre}',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(color: Colors.white12, height: 1),

                // ✅ Marcar como pagado (si no está pagado)
                if (!pago.estaPagado)
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF2E7D32),
                      child: Icon(Icons.check, color: Colors.white),
                    ),
                    title: const Text(
                      'Marcar como pagado',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () async {
                      Navigator.pop(bottomSheetContext);
                      final vm = Provider.of<PagosViewModel>(context, listen: false);

                      try {
                        await vm.marcarPagado(pago.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('✅ Pago de ${pago.inquilinoNombre} marcado como pagado'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('❌ Error: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                  ),

                // ✅ Editar
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFFFA000),
                    child: Icon(Icons.edit, color: Colors.white),
                  ),
                  title: const Text(
                    'Editar pago',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AgregarPagoVista(pago: pago),
                      ),
                    );
                  },
                ),

                // ✅ Eliminar
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFD32F2F),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  title: const Text(
                    'Eliminar pago',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    _confirmarEliminar(context, pago);
                  },
                ),

                const SizedBox(height: 8),

                // Cancelar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(bottomSheetContext),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ✅ NUEVO: Confirmar eliminación
  void _confirmarEliminar(BuildContext context, pago) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          '¿Eliminar pago?',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Se eliminará el pago de ${pago.inquilinoNombre} por \$${pago.monto.toStringAsFixed(0)}',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);

              final vm = Provider.of<PagosViewModel>(context, listen: false);

              // Mostrar loading
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(
                  child: CircularProgressIndicator(color: Colors.amber),
                ),
              );

              try {
                await vm.eliminar(pago.id);

                if (context.mounted) {
                  Navigator.pop(context); // Cerrar loading
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Pago eliminado correctamente'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context); // Cerrar loading
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('❌ Error al eliminar: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildResumen(PagosViewModel vm) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.withOpacity(0.2),
            Colors.amber.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildEstadistica(
            'Pendientes',
            vm.pagosPendientes.length.toString(),
            Colors.orange,
            Icons.pending,
          ),
          Container(width: 1, height: 40, color: Colors.white12),
          _buildEstadistica(
            'Morosos',
            vm.pagosMorosos.length.toString(),
            Colors.red,
            Icons.warning,
          ),
          Container(width: 1, height: 40, color: Colors.white12),
          _buildEstadistica(
            'Este mes',
            '\$${vm.ingresosDelMes.toStringAsFixed(0)}',
            Colors.green,
            Icons.attach_money,
          ),
        ],
      ),
    );
  }

  Widget _buildEstadistica(String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Color _getEstadoColor(String estado) {
    switch (estado) {
      case 'pagado':
        return Colors.green;
      case 'pendiente':
        return Colors.orange;
      case 'moroso':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getEstadoIcon(String estado) {
    switch (estado) {
      case 'pagado':
        return Icons.check_circle;
      case 'pendiente':
        return Icons.pending;
      case 'moroso':
        return Icons.warning;
      default:
        return Icons.help;
    }
  }
}