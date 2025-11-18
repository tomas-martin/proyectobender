import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modelos/reporte_problema.dart';
import '../modelos/propiedad.dart';
import '../vista_modelos/reportes_vm.dart';
import '../vista_modelos/propiedades_vm.dart';

class AgregarReporteVista extends StatefulWidget {
  final ReporteProblema? reporte;

  const AgregarReporteVista({super.key, this.reporte});

  @override
  State<AgregarReporteVista> createState() => _AgregarReporteVistaState();
}

class _AgregarReporteVistaState extends State<AgregarReporteVista> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();

  Propiedad? _propiedadSeleccionada;
  String _categoriaSeleccionada = 'mantenimiento';
  String _prioridadSeleccionada = 'media';
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    if (widget.reporte != null) {
      _tituloController.text = widget.reporte!.titulo;
      _descripcionController.text = widget.reporte!.descripcion;
      _categoriaSeleccionada = widget.reporte!.categoria;
      _prioridadSeleccionada = widget.reporte!.prioridad;

      // Buscar la propiedad seleccionada
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final propiedadesVM =
        Provider.of<PropiedadesViewModel>(context, listen: false);
        final prop = propiedadesVM.propiedades.firstWhere(
              (p) => p.id == widget.reporte!.propiedadId,
          orElse: () => propiedadesVM.propiedades.first,
        );
        setState(() {
          _propiedadSeleccionada = prop;
        });
      });
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    if (_propiedadSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Debes seleccionar una propiedad'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _guardando = true);

    try {
      final vm = Provider.of<ReportesViewModel>(context, listen: false);

      final reporte = ReporteProblema(
        id: widget.reporte?.id ?? '',
        propiedadId: _propiedadSeleccionada!.id,
        propiedadTitulo: _propiedadSeleccionada!.titulo,
        titulo: _tituloController.text.trim(),
        descripcion: _descripcionController.text.trim(),
        categoria: _categoriaSeleccionada,
        prioridad: _prioridadSeleccionada,
        estado: widget.reporte?.estado ?? 'pendiente',
        fechaReporte: widget.reporte?.fechaReporte ?? DateTime.now(),
      );

      if (widget.reporte == null) {
        await vm.agregar(reporte);
      } else {
        await vm.actualizar(widget.reporte!.id, reporte);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.reporte == null
                ? '✅ Reporte creado correctamente'
                : '✅ Reporte actualizado correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _guardando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final propiedadesVM = Provider.of<PropiedadesViewModel>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(widget.reporte == null
            ? 'Reportar Problema'
            : 'Editar Reporte'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header informativo
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.report_problem, color: Colors.red),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Reporta problemas en las propiedades para dar seguimiento',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // PROPIEDAD
              const Text(
                'Propiedad',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              propiedadesVM.propiedades.isEmpty
                  ? Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border:
                  Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'No hay propiedades registradas',
                        style:
                        TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              )
                  : DropdownButtonFormField<Propiedad>(
                value: _propiedadSeleccionada,
                dropdownColor: const Color(0xFF1E1E1E),
                isExpanded: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.home, color: Colors.amber),
                ),
                hint: const Text(
                  'Selecciona una propiedad',
                  style: TextStyle(color: Colors.white54),
                ),
                items: propiedadesVM.propiedades.map((prop) {
                  return DropdownMenuItem<Propiedad>(
                    value: prop,
                    child: Text(
                      prop.titulo,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _propiedadSeleccionada = value);
                },
                validator: (value) {
                  if (value == null) return 'Selecciona una propiedad';
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // TÍTULO
              const Text(
                'Título del Problema',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: _tituloController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Ej: Fuga de agua en el baño',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: const Icon(Icons.title, color: Colors.amber),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El título es obligatorio';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // DESCRIPCIÓN
              const Text(
                'Descripción',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: _descripcionController,
                style: const TextStyle(color: Colors.white),
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Describe el problema en detalle...',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La descripción es obligatoria';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // CATEGORÍA
              const Text(
                'Categoría',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Column(
                  children: [
                    _buildRadioTile(
                      'Mantenimiento',
                      'mantenimiento',
                      Icons.build,
                      Colors.blue,
                    ),
                    const Divider(color: Colors.white12, height: 1),
                    _buildRadioTile(
                      'Plomería',
                      'plomeria',
                      Icons.plumbing,
                      Colors.cyan,
                    ),
                    const Divider(color: Colors.white12, height: 1),
                    _buildRadioTile(
                      'Electricidad',
                      'electricidad',
                      Icons.electrical_services,
                      Colors.yellow,
                    ),
                    const Divider(color: Colors.white12, height: 1),
                    _buildRadioTile(
                      'Limpieza',
                      'limpieza',
                      Icons.cleaning_services,
                      Colors.green,
                    ),
                    const Divider(color: Colors.white12, height: 1),
                    _buildRadioTile(
                      'Otro',
                      'otro',
                      Icons.more_horiz,
                      Colors.grey,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // PRIORIDAD
              const Text(
                'Prioridad',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Column(
                  children: [
                    _buildPrioridadTile('Alta', 'alta', Colors.red, Icons.priority_high),
                    const Divider(color: Colors.white12, height: 1),
                    _buildPrioridadTile('Media', 'media', Colors.orange, Icons.remove),
                    const Divider(color: Colors.white12, height: 1),
                    _buildPrioridadTile('Baja', 'baja', Colors.green, Icons.arrow_downward),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // BOTÓN GUARDAR
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: (_guardando ||
                      propiedadesVM.propiedades.isEmpty)
                      ? null
                      : _guardar,
                  icon: _guardando
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  )
                      : const Icon(Icons.save),
                  label: Text(_guardando ? 'Guardando...' : 'Guardar Reporte'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioTile(
      String label,
      String value,
      IconData icon,
      Color color,
      ) {
    return RadioListTile<String>(
      title: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
      value: value,
      groupValue: _categoriaSeleccionada,
      activeColor: Colors.amber,
      onChanged: (val) => setState(() => _categoriaSeleccionada = val!),
    );
  }

  Widget _buildPrioridadTile(
      String label,
      String value,
      Color color,
      IconData icon,
      ) {
    return RadioListTile<String>(
      title: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
      value: value,
      groupValue: _prioridadSeleccionada,
      activeColor: Colors.amber,
      onChanged: (val) => setState(() => _prioridadSeleccionada = val!),
    );
  }
}