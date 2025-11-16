import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modelos/propiedad.dart';
import '../vista_modelos/propiedades_vm.dart';
import '../vista_modelos/pagos_vm.dart';
import '../vista_modelos/navigation_viewmodel.dart';
import '../servicios/storage_servicio.dart';

import 'agregar_propiedad_vista.dart';
import 'agregar_pago_vista.dart';

class PropiedadDetalleVista extends StatelessWidget {
  final Propiedad propiedad;

  const PropiedadDetalleVista({super.key, required this.propiedad});

  @override
  Widget build(BuildContext context) {
    final pagosVM = Provider.of<PagosViewModel>(context);
    final ultimoPago = pagosVM.obtenerUltimoPago(propiedad.id);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Detalle de Propiedad'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'cambiar_estado',
                child: Row(
                  children: [
                    Icon(Icons.swap_horiz, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Cambiar estado'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'editar',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.amber),
                    SizedBox(width: 8),
                    Text('Editar'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'eliminar',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Eliminar'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'editar') {
                _editarPropiedad(context);
              } else if (value == 'eliminar') {
                _mostrarDialogoEliminar(context);
              } else if (value == 'cambiar_estado') {
                _cambiarEstado(context);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImagen(),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TÍTULO
                  Text(
                    propiedad.titulo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// DIRECCIÓN
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          propiedad.direccion,
                          style: const TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  /// PRECIO
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.amber.withOpacity(0.2),
                          Colors.amber.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.amber.withOpacity(0.3), width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Alquiler Mensual',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${propiedad.alquilerMensual.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// ESTADO
                  const Text(
                    'Estado',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  propiedad.estaAlquilada
                      ? _buildEstadoChip('Alquilada', Colors.red, Icons.close)
                      : _buildEstadoChip('Disponible', Colors.green, Icons.check_circle),

                  const SizedBox(height: 24),

                  /// INFORMACIÓN
                  const Text(
                    'Información',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  _buildInfoItem(
                    Icons.calendar_today,
                    'Fecha de registro',
                    propiedad.fechaRegistro,
                    Colors.purple,
                  ),

                  const SizedBox(height: 12),

                  _buildInfoItem(
                    Icons.payment,
                    'Último pago',
                    ultimoPago != null
                        ? '${ultimoPago.fecha.day}/${ultimoPago.fecha.month}/${ultimoPago.fecha.year}'
                        : 'Sin pagos registrados',
                    Colors.orange,
                  ),

                  const SizedBox(height: 12),

                  _buildInfoItem(
                    Icons.door_front_door,
                    'Tipo',
                    propiedad.tipo,
                    Colors.cyan,
                  ),

                  const SizedBox(height: 32),

                  /// BOTONES DE PAGO
                  if (propiedad.estaAlquilada) ...[
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _verPagosPropiedad(context),
                        icon: const Icon(Icons.receipt_long),
                        label: const Text("Ver Pagos"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.amber,
                          side: const BorderSide(color: Colors.amber),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AgregarPagoVista(propiedadId: propiedad.id),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text("Registrar Pago"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  /// BOTONES EDITAR - ELIMINAR
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _editarPropiedad(context),
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
                          onPressed: () => _mostrarDialogoEliminar(context),
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
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // # IMAGEN
  // ==========================================================

  Widget _buildImagen() {
    if (propiedad.imagen.isNotEmpty) {
      return Image.network(
        propiedad.imagen,
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildImagenPlaceholder(),
      );
    }
    return _buildImagenPlaceholder();
  }

  Widget _buildImagenPlaceholder() {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey[900]!, Colors.grey[800]!],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home_work, size: 64, color: Colors.white24),
            SizedBox(height: 12),
            Text('Sin imagen disponible',
                style: TextStyle(color: Colors.white38, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // # WIDGETS ÚTILES
  // ==========================================================

  Widget _buildEstadoChip(String texto, Color color, IconData icono) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            texto,
            style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icono, String titulo, String valor, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icono, color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                const SizedBox(height: 4),
                Text(valor,
                    style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // # ACCIONES
  // ==========================================================

  void _editarPropiedad(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AgregarPropiedadVista(propiedad: propiedad)),
    );
  }

  void _verPagosPropiedad(BuildContext context) {
    final pagosVM = Provider.of<PagosViewModel>(context, listen: false);
    final nav = Provider.of<NavigationViewModel>(context, listen: false);

    pagosVM.cargarPagosDePropiedad(propiedad.id);

    Navigator.pop(context); // Cerrar detalle
    nav.cambiarIndice(2); // Ir a vista de pagos
  }

  void _cambiarEstado(BuildContext context) async {
    final vm = Provider.of<PropiedadesViewModel>(context, listen: false);

    final nuevoEstado = propiedad.estaAlquilada ? 'disponible' : 'alquilada';

    // ✅ CORREGIDO: Usar copyWith para crear nueva instancia
    final propiedadActualizada = propiedad.copyWith(
      estado: nuevoEstado,
      // Si cambia a disponible, limpiar inquilino
      inquilinoId: nuevoEstado == 'disponible' ? null : propiedad.inquilinoId,
      inquilinoNombre: nuevoEstado == 'disponible' ? null : propiedad.inquilinoNombre,
    );

    await vm.actualizar(propiedad.id, propiedadActualizada);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(nuevoEstado == 'alquilada'
              ? "✅ La propiedad ahora está marcada como ALQUILADA"
              : "✅ La propiedad ahora está marcada como DISPONIBLE"),
          backgroundColor: Colors.green,
        ),
      );

      // Volver atrás para refrescar
      Navigator.pop(context);
    }
  }

  // ==========================================================
  // # ELIMINAR PROPIEDAD
  // ==========================================================

  void _mostrarDialogoEliminar(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('¿Eliminar propiedad?', style: TextStyle(color: Colors.white)),
        content: Text(
          propiedad.titulo,
          style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await _eliminarPropiedad(context);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _eliminarPropiedad(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Colors.amber),
      ),
    );

    try {
      final vm = Provider.of<PropiedadesViewModel>(context, listen: false);

      if (propiedad.imagen.isNotEmpty && propiedad.imagen.contains('firebase')) {
        await StorageServicio().eliminarImagen(propiedad.imagen);
      }

      await vm.eliminar(propiedad.id);

      if (context.mounted) {
        Navigator.pop(context);
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Propiedad eliminada correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}