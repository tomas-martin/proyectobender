import 'package:flutter/material.dart';
import 'package:probando_app_bender_v0/vistas/propiedades_detalle_vista.dart';
import 'package:provider/provider.dart';
import '../vista_modelos/propiedades_vm.dart';
import '../widgets/tarjeta_propiedad.dart';
import 'propiedades_detalle_vista.dart';
import 'agregar_propiedad_vista.dart';

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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              vm.escucharPropiedades();
            },
          ),
        ],
      ),
      body: vm.cargando
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.amber),
            SizedBox(height: 16),
            Text(
              'Cargando propiedades...',
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
                  vm.escucharPropiedades();
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
          : vm.propiedades.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home_work_outlined,
              size: 80,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            const Text(
              "No hay propiedades cargadas",
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
          : ListView.builder(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 80,
        ),
        itemCount: vm.propiedades.length,
        itemBuilder: (context, i) {
          final p = vm.propiedades[i];
          return Column(
            children: [
              TarjetaPropiedad(
                titulo: p.titulo,
                descripcion: p.direccion,
                icono: Icons.home,
                color: Colors.orangeAccent,
                precio: p.alquilerMensual,
                mostrarBoton: false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PropiedadDetalleVista(propiedad: p),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
      // 👇👇👇 AQUÍ ESTÁ EL BOTÓN FLOTANTE 👇👇👇
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AgregarPropiedadVista(),
            ),
          );
        },
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
    );
  }
}