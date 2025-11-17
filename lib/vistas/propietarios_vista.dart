import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../vista_modelos/propietarios_vm.dart';
import 'agregar_propietario_vista.dart';

class PropietariosVista extends StatelessWidget {
  const PropietariosVista({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PropietariosViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Propietarios (${vm.propietarios.length})'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => vm.escucharPropietarios(),
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
            Text('Cargando propietarios...', style: TextStyle(color: Colors.white70)),
          ],
        ),
      )
          : vm.propietarios.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_outline, size: 80, color: Colors.white.withOpacity(0.3)),
            const SizedBox(height: 16),
            const Text(
              'No hay propietarios registrados',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const Text(
              'Toca el botón + para agregar',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
        itemCount: vm.propietarios.length,
        itemBuilder: (context, i) {
          final p = vm.propietarios[i];
          return Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _mostrarDetalle(context, p),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.purple.withOpacity(0.2),
                      radius: 28,
                      child: Text(
                        p.nombre[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.purple,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.nombre,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.phone, color: Colors.white54, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                p.telefono,
                                style: const TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.email, color: Colors.white54, size: 14),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  p.email,
                                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AgregarPropietarioVista()),
          );
        },
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text('Agregar Propietario'),
      ),
    );
  }

  void _mostrarDetalle(BuildContext context, propietario) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.purple.withOpacity(0.2),
                      radius: 30,
                      child: Text(
                        propietario.nombre[0].toUpperCase(),
                        style: const TextStyle(color: Colors.purple, fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            propietario.nombre,
                            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Registrado: ${propietario.fechaFormateada}',
                            style: const TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: Colors.white12),

                // Información
                _buildInfoItem(Icons.phone, 'Teléfono', propietario.telefono),
                _buildInfoItem(Icons.email, 'Email', propietario.email),
                if (propietario.direccion != null)
                  _buildInfoItem(Icons.location_on, 'Dirección', propietario.direccion!),
                if (propietario.notas != null)
                  _buildInfoItem(Icons.notes, 'Notas', propietario.notas!),

                const SizedBox(height: 20),

                // Botones
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(bottomContext);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AgregarPropietarioVista(propietario: propietario),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Editar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(bottomContext);
                          _confirmarEliminar(context, propietario);
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text('Eliminar'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.amber, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmarEliminar(BuildContext context, propietario) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('¿Eliminar propietario?', style: TextStyle(color: Colors.white)),
        content: Text(
          'Se eliminará a ${propietario.nombre}',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final vm = Provider.of<PropietariosViewModel>(context, listen: false);

              try {
                await vm.eliminar(propietario.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('✅ Propietario eliminado'), backgroundColor: Colors.green),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('❌ Error: $e'), backgroundColor: Colors.red),
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
}