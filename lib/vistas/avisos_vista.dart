import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../vista_modelos/avisos_vm.dart';
import '../modelos/aviso.dart';

class AvisosVista extends StatelessWidget {
  const AvisosVista({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AvisosViewModel>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text('Avisos (${vm.cantidadNoLeidos} sin leer)'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => vm.escucharAvisos(),
          ),
        ],
      ),
      body: vm.cargando
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : vm.avisos.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 80, color: Colors.white.withOpacity(0.3)),
            const SizedBox(height: 16),
            const Text('No hay avisos', style: TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 8),
            const Text('Toca + para crear uno', style: TextStyle(color: Colors.white70)),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
        itemCount: vm.avisos.length,
        itemBuilder: (context, i) {
          final a = vm.avisos[i];
          return Card(
            color: a.leido
                ? Theme.of(context).colorScheme.surfaceContainerHighest
                : Colors.amber.withOpacity(0.1),
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: a.leido
                  ? BorderSide.none
                  : BorderSide(color: Colors.amber.withOpacity(0.3)),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _mostrarDetalle(context, a),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _getColorPrioridad(a.prioridad).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        a.leido ? Icons.notifications : Icons.notification_important,
                        color: _getColorPrioridad(a.prioridad),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            a.titulo,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: a.leido ? FontWeight.normal : FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            a.descripcion,
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            a.fechaFormateada,
                            style: const TextStyle(color: Colors.white38, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white.withOpacity(0.3),
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarFormulario(context),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text('Crear Aviso'),
      ),
    );
  }

  Color _getColorPrioridad(String prioridad) {
    switch (prioridad) {
      case 'alta':
        return Colors.red;
      case 'baja':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  void _mostrarDetalle(BuildContext context, Aviso aviso) {
    // Marcar como leído
    if (!aviso.leido) {
      Provider.of<AvisosViewModel>(context, listen: false).marcarLeido(aviso.id);
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomContext) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _getColorPrioridad(aviso.prioridad).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.notification_important,
                      color: _getColorPrioridad(aviso.prioridad),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          aviso.titulo,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Prioridad: ${aviso.prioridad} • ${aviso.fechaFormateada}',
                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.white12),
              const SizedBox(height: 12),
              Text(
                aviso.descripcion,
                style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.5),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(bottomContext);
                        _mostrarFormulario(context, aviso: aviso);
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
                        _confirmarEliminar(context, aviso);
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
        );
      },
    );
  }

  void _mostrarFormulario(BuildContext context, {Aviso? aviso}) {
    final tituloController = TextEditingController(text: aviso?.titulo ?? '');
    final descripcionController = TextEditingController(text: aviso?.descripcion ?? '');
    String prioridadSeleccionada = aviso?.prioridad ?? 'media';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E1E1E),
              title: Text(
                aviso == null ? 'Nuevo Aviso' : 'Editar Aviso',
                style: const TextStyle(color: Colors.white),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: tituloController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Título',
                        labelStyle: TextStyle(color: Colors.white54),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descripcionController,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        labelStyle: TextStyle(color: Colors.white54),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: prioridadSeleccionada,
                      dropdownColor: const Color(0xFF2E2E2E),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Prioridad',
                        labelStyle: TextStyle(color: Colors.white54),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'alta', child: Text('Alta')),
                        DropdownMenuItem(value: 'media', child: Text('Media')),
                        DropdownMenuItem(value: 'baja', child: Text('Baja')),
                      ],
                      onChanged: (value) {
                        setState(() => prioridadSeleccionada = value!);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (tituloController.text.trim().isEmpty) return;

                    final vm = Provider.of<AvisosViewModel>(context, listen: false);
                    final nuevoAviso = Aviso(
                      id: aviso?.id ?? '',
                      titulo: tituloController.text.trim(),
                      descripcion: descripcionController.text.trim(),
                      prioridad: prioridadSeleccionada,
                    );

                    try {
                      if (aviso == null) {
                        await vm.agregar(nuevoAviso);
                      } else {
                        await vm.actualizar(aviso.id, nuevoAviso);
                      }
                      if (context.mounted) Navigator.pop(dialogContext);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmarEliminar(BuildContext context, Aviso aviso) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('¿Eliminar aviso?', style: TextStyle(color: Colors.white)),
        content: Text(aviso.titulo, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final vm = Provider.of<AvisosViewModel>(context, listen: false);
              try {
                await vm.eliminar(aviso.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('✅ Aviso eliminado'), backgroundColor: Colors.green),
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