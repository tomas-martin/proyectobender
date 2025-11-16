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
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getEstadoColor(p.estado).withOpacity(0.2),
                      child: Icon(
                        _getEstadoIcon(p.estado),
                        color: _getEstadoColor(p.estado),
                      ),
                    ),
                    title: Text(
                      p.propiedadTitulo,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.inquilinoNombre,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '\$${p.monto.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
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
                          ],
                        ),
                      ],
                    ),
                    trailing: p.estaPagado
                        ? const Icon(
                      Icons.check_circle,
                      color: Colors.greenAccent,
                    )
                        : IconButton(
                      icon: const Icon(
                        Icons.check,
                        color: Colors.amber,
                      ),
                      onPressed: () async {
                        await vm.marcarPagado(p.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '✅ Pago de ${p.inquilinoNombre} marcado como pagado',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AgregarPagoVista(pago: p),
                        ),
                      );
                    },
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