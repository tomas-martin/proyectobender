import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modelos/recordatorio_pago.dart';
import '../modelos/propiedad.dart';
import '../vista_modelos/recordatorios_vm.dart';
import '../vista_modelos/propiedades_vm.dart';

class AgregarRecordatorioVista extends StatefulWidget {
  final RecordatorioPago? recordatorio;

  const AgregarRecordatorioVista({super.key, this.recordatorio});

  @override
  State<AgregarRecordatorioVista> createState() =>
      _AgregarRecordatorioVistaState();
}

class _AgregarRecordatorioVistaState extends State<AgregarRecordatorioVista> {
  final _formKey = GlobalKey<FormState>();
  final _montoController = TextEditingController();

  Propiedad? _propiedadSeleccionada;
  DateTime _fechaVencimiento = DateTime.now().add(const Duration(days: 30));
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    if (widget.recordatorio != null) {
      _montoController.text = widget.recordatorio!.monto.toString();
      _fechaVencimiento = widget.recordatorio!.fechaVencimiento;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final propiedadesVM =
        Provider.of<PropiedadesViewModel>(context, listen: false);
        final prop = propiedadesVM.propiedades.firstWhere(
              (p) => p.id == widget.recordatorio!.propiedadId,
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
    _montoController.dispose();
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
      final vm = Provider.of<RecordatoriosViewModel>(context, listen: false);

      final recordatorio = RecordatorioPago(
        id: widget.recordatorio?.id ?? '',
        propiedadId: _propiedadSeleccionada!.id,
        propiedadTitulo: _propiedadSeleccionada!.titulo,
        propietarioId: _propiedadSeleccionada!.propietarioId ?? '',
        propietarioNombre:
        _propiedadSeleccionada!.propietarioNombre ?? 'Sin propietario',
        monto: double.parse(_montoController.text.trim()),
        fechaVencimiento: _fechaVencimiento,
        estado: widget.recordatorio?.estado ?? 'pendiente',
        notificado: widget.recordatorio?.notificado ?? false,
        fechaNotificacion: widget.recordatorio?.fechaNotificacion,
      );

      if (widget.recordatorio == null) {
        await vm.agregar(recordatorio);
      } else {
        await vm.actualizar(widget.recordatorio!.id, recordatorio);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.recordatorio == null
                ? '✅ Recordatorio creado correctamente'
                : '✅ Recordatorio actualizado correctamente'),
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
        title: Text(widget.recordatorio == null
            ? 'Nuevo Recordatorio'
            : 'Editar Recordatorio'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min, // ← ← FIX PARA EL OVERFLOW
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header informativo
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.schedule, color: Colors.orange),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Crea recordatorios automáticos para pagos próximos',
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
                        style: TextStyle(
                            color: Colors.white70, fontSize: 13),
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
                  setState(() {
                    _propiedadSeleccionada = value;
                    if (value != null) {
                      _montoController.text =
                          value.alquilerMensual.toString();
                    }
                  });
                },
                validator: (value) {
                  if (value == null) return 'Selecciona una propiedad';
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // PROPIETARIO (READ-ONLY)
              const Text(
                'Propietario',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person, color: Colors.purple),
                    const SizedBox(width: 12),
                    Text(
                      _propiedadSeleccionada?.propietarioNombre ??
                          'Selecciona una propiedad',
                      style: TextStyle(
                        color: _propiedadSeleccionada != null
                            ? Colors.white
                            : Colors.white38,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // MONTO
              const Text(
                'Monto',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: _montoController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Ej: 15000',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon:
                  const Icon(Icons.attach_money, color: Colors.amber),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El monto es obligatorio';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Ingresa un número válido';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // FECHA DE VENCIMIENTO
              const Text(
                'Fecha de Vencimiento',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              InkWell(
                onTap: () async {
                  final fecha = await showDatePicker(
                    context: context,
                    initialDate: _fechaVencimiento,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          dialogBackgroundColor: const Color(0xFF1E1E1E),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (fecha != null) {
                    setState(() => _fechaVencimiento = fecha);
                  }
                },
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.amber),
                      const SizedBox(width: 12),
                      Text(
                        '${_fechaVencimiento.day}/${_fechaVencimiento.month}/${_fechaVencimiento.year}',
                        style:
                        const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const Spacer(),
                      const Icon(Icons.edit, color: Colors.white54, size: 18),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Info sobre días restantes
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info, color: Colors.blue, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _calcularDiasRestantes(),
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // BOTÓN GUARDAR
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed:
                  (_guardando || propiedadesVM.propiedades.isEmpty)
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
                  label: Text(
                      _guardando ? 'Guardando...' : 'Guardar Recordatorio'),
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

  String _calcularDiasRestantes() {
    final ahora = DateTime.now();
    final diferencia = _fechaVencimiento.difference(ahora).inDays;

    if (diferencia < 0) {
      return 'Fecha pasada: ${diferencia.abs()} días de retraso';
    } else if (diferencia == 0) {
      return 'Vence hoy';
    } else if (diferencia == 1) {
      return 'Vence mañana';
    } else if (diferencia <= 7) {
      return 'Vence en $diferencia días (próximamente)';
    } else {
      return 'Vence en $diferencia días';
    }
  }
}
