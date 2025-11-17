import 'package:flutter/material.dart';
import 'package:probando_app_bender_v0/modelos/error_sistema.dart';
import 'package:provider/provider.dart';
import '../vista_modelos/errores_vm.dart';
import '../modelos/error_sistema.dart';

class ErroresVista extends StatelessWidget {
  const ErroresVista({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ErroresViewModel>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text('Errores (${vm.cantidadNoResueltos} sin resolver)'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => vm.escucharErrores(),
          ),
        ],
      ),
      body: vm.cargando
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : vm.errores.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 80, color: Colors.green.withOpacity(0.3)),
            const SizedBox(height: 16),
            const Text('No hay errores registrados', style: TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 8),
            const Text('¡Todo funciona correctamente!', style: TextStyle(color: Colors.white70)),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
        itemCount: vm.errores.length,
        itemBuilder: (context, i) {
          final e = vm.errores[i];
          return Card(
            color: e.resuelto
                ? Colors.green.withOpacity(0.1)
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: e.resuelto
                  ? BorderSide(color: Colors.green.withOpacity(0.3))
                  : BorderSide.none,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _mostrarDetalle(context, e),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _getColorTipo(e.tipo).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getIconoTipo(e.tipo),
                        color: _getColorTipo(e.tipo),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  e.titulo,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: e.resuelto ? FontWeight.normal : FontWeight.bold,
                                    fontSize: 16,
                                    decoration: e.resuelto ? TextDecoration.lineThrough : null,
                                  ),
                                ),
                              ),
                              if (e.resuelto)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'RESUELTO',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            e.descripcion,
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                e.tipo.toUpperCase(),
                                style: TextStyle(
                                  color: _getColorTipo(e.tipo),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                e.fechaFormateada,
                                style: const TextStyle(color: Colors.white38, fontSize: 11),
                              ),
                            ],
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
        label: const Text('Reportar Error'),
      ),
    );
  }

  Color _getColorTipo(String tipo) {
    switch (tipo) {
      case 'critico':
        return Colors.red;
      case 'info':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  IconData _getIconoTipo(String tipo) {
    switch (tipo) {
      case 'critico':
        return Icons.error;
      case 'info':
        return Icons.info;
      default:
        return Icons.warning;
    }
  }

  void _mostrarDetalle(BuildContext context, ErrorSistema error) {
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
                      color: _getColorTipo(error.tipo).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getIconoTipo(error.tipo),
                      color: _getColorTipo(error.tipo),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          error.titulo,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Tipo: ${error.tipo} • ${error.fechaFormateada}',
                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  if (error.resuelto)
                    const Icon(Icons.check_circle, color: Colors.green, size: 32),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.white12),
              const SizedBox(height: 12),
              const Text(
                'Descripción:',
                style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                error.descripcion,
                style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.5),
              ),
              if (error.solucion != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: 16),
                          SizedBox(width: 8),
                          Text(
                            'Solución aplicada:',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        error.solucion!,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              if (!error.resuelto)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(bottomContext);
                      _marcarResuelto(context, error);
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Marcar como Resuelto'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(bottomContext);
                        _mostrarFormulario(context, error: error);
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Editar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.amber,
                        side: const BorderSide(color: Colors.amber),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(bottomContext);
                        _confirmarEliminar(context, error);
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

  void _marcarResuelto(BuildContext context, ErrorSistema error) {
    final solucionController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Marcar como Resuelto', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '¿Cómo se solucionó este error?',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: solucionController,
              style: const TextStyle(color: Colors.white),
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Describe la solución aplicada...',
                hintStyle: TextStyle(color: Colors.white38),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (solucionController.text.trim().isEmpty) return;

              final vm = Provider.of<ErroresViewModel>(context, listen: false);
              try {
                await vm.marcarResuelto(error.id, solucionController.text.trim());
                if (context.mounted) {
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Error marcado como resuelto'),
                      backgroundColor: Colors.green,
                    ),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _mostrarFormulario(BuildContext context, {ErrorSistema? error}) {
    final tituloController = TextEditingController(text: error?.titulo ?? '');
    final descripcionController = TextEditingController(text: error?.descripcion ?? '');
    String tipoSeleccionado = error?.tipo ?? 'advertencia';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E1E1E),
              title: Text(
                error == null ? 'Reportar Error' : 'Editar Error',
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
                        labelText: 'Título del Error',
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
                      value: tipoSeleccionado,
                      dropdownColor: const Color(0xFF2E2E2E),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Tipo',
                        labelStyle: TextStyle(color: Colors.white54),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'critico', child: Text('Crítico')),
                        DropdownMenuItem(value: 'advertencia', child: Text('Advertencia')),
                        DropdownMenuItem(value: 'info', child: Text('Información')),
                      ],
                      onChanged: (value) {
                        setState(() => tipoSeleccionado = value!);
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

                    final vm = Provider.of<ErroresViewModel>(context, listen: false);
                    final nuevoError = ErrorSistema(
                      id: error?.id ?? '',
                      titulo: tituloController.text.trim(),
                      descripcion: descripcionController.text.trim(),
                      tipo: tipoSeleccionado,
                    );

                    try {
                      if (error == null) {
                        await vm.agregar(nuevoError);
                      } else {
                        await vm.actualizar(error.id, nuevoError);
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

  void _confirmarEliminar(BuildContext context, ErrorSistema error) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('¿Eliminar error?', style: TextStyle(color: Colors.white)),
        content: Text(error.titulo, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final vm = Provider.of<ErroresViewModel>(context, listen: false);
              try {
                await vm.eliminar(error.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('✅ Error eliminado'), backgroundColor: Colors.green),
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