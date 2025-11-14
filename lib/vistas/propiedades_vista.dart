import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../vista_modelos/propiedades_vm.dart';
import '../widgets/tarjeta_propiedad.dart';

class PropiedadesVista extends StatelessWidget {
  const PropiedadesVista({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PropiedadesViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Propiedades'),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),

      body: vm.cargando
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : vm.propiedades.isEmpty
          ? const Center(
        child: Text(
          "No hay propiedades cargadas",
          style: TextStyle(color: Colors.white),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: vm.propiedades.length,
        itemBuilder: (context, i) {
          final p = vm.propiedades[i];
          return Column(
            children: [
              TarjetaPropiedad(
                titulo: p.titulo,
                descripcion:
                "${p.direccion}\nAlquiler: \$${p.alquilerMensual}",
                icono: Icons.home,
                color: Colors.orangeAccent,
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}
