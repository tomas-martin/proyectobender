import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../vista_modelos/navigation_viewmodel.dart';
import '../vista_modelos/pagos_vm.dart';

class PagosVista extends StatelessWidget {
  const PagosVista({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PagosViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagos'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: vm.pagos.isEmpty
          ? const Center(
        child: Text(
          'No hay pagos registrados.',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: vm.pagos.length,
        itemBuilder: (context, i) {
          final p = vm.pagos[i];
          return Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.deepPurpleAccent,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                p.inquilino,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Monto: \$${p.monto.toStringAsFixed(0)} • Estado: ${p.estado}',
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: IconButton(
                icon: Icon(
                  p.estado == 'pagado'
                      ? Icons.check_circle
                      : Icons.payment,
                  color: p.estado == 'pagado'
                      ? Colors.greenAccent
                      : Colors.amber,
                ),
                onPressed: () {
                  vm.marcarPagado(p.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Pago de ${p.inquilino} marcado como pagado'),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}