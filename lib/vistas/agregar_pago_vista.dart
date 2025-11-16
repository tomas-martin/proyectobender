import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modelos/pago.dart';
import '../modelos/propiedad.dart';
import '../vista_modelos/pagos_vm.dart';
import '../vista_modelos/propiedades_vm.dart';

class AgregarPagoVista extends StatefulWidget {
  final Pago? pago;
  final Propiedad? propiedadPreseleccionada;

  const AgregarPagoVista({
    super.key,
    this.pago,
    this.propiedadPreseleccionada,
  });

  @override
  State<AgregarPagoVista> createState() => _AgregarPagoVistaState();
}

class _AgregarPagoVistaState extends State<AgregarPagoVista> {
  final _formKey = GlobalKey<FormState>();
  final _montoController = TextEditingController();

  Propiedad? _propiedadSeleccionada;
  String _estadoSeleccionado = 'pendiente';
  DateTime _fechaSeleccionada = DateTime.now();
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _propiedadSeleccionada = widget.propiedadPreseleccionada;

    if (widget.pago != null) {
      _montoController.text = widget.pago!.monto.toString();
      _estadoSeleccionado = widget.pago!.estado;
      _fechaSeleccionada = widget.pago!.fecha;
    }
  }

  @override
  void dispose() {
    _montoController.dispose();
    super.dispose();
  }

  Future<void> _guardarPago() async {
    if (!_formKey.currentState!.validate()) return;
    if (_propiedadSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Selecciona una propiedad'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _guardando = true);

    try {
      final pagosVM = Provider.of<PagosViewModel>(context, listen: false);

      final pago = Pago(
        id: widget.pago?.id ?? '',
        propiedadId: _propiedadSeleccionada!.id,
        propiedadTitulo: _propiedadSeleccionada!.titulo,
        inquilinoId: _propiedadSeleccionada!.inquilinoId ?? '',
        inquilinoNombre: _propiedadSeleccionada!.inquilinoNombre ?? 'Sin inquilino',
        monto: double.parse(_montoController.text.trim()),
        estado: _estadoSeleccionado,
        fecha: _fechaSeleccionada,
      );

      if (widget.pago == null) {
        await pagosVM.agregar(pago);
      } else {
        await pagosVM.actualizar(widget.pago!.id, pago);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.pago == null
                ? '✅ Pago registrado correctamente'
                : '✅ Pago actualizado correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al guardar: $e'),
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
    final propiedadesAlquiladas = propiedadesVM.propiedades
        .where((p) => p.estaAlquilada)
        .toList();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(widget.pago == null ? 'Registrar Pago' : 'Editar Pago'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Seleccionar propiedad
              const Text(
                'Propiedad',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              if (propiedadesAlquiladas.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'No hay propiedades alquiladas. Primero marca una propiedad como "Alquilada".',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[700]!),
                  ),
                  child: DropdownButtonFormField<Propiedad>(
                    value: _propiedadSeleccionada,
                    dropdownColor: const Color(0xFF1E1E1E),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.home, color: Colors.amber),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    hint: const Text(
                      'Selecciona una propiedad',
                      style: TextStyle(color: Colors.white54),
                    ),
                    items: propiedadesAlquiladas.map((prop) {
                      return DropdownMenuItem(
                        value: prop,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              prop.titulo,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${prop.inquilinoNombre} • \$${prop.alquilerMensual.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _propiedadSeleccionada = value;
                        if (value != null) {
                          _montoController.text = value.alquilerMensual.toString();
                        }
                      });
                    },
                  ),
                ),
              const SizedBox(height: 20),

              // Monto
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
                  hintText: 'Ej: 1500',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixText: '\$ ',
                  prefixStyle: const TextStyle(color: Colors.amber, fontSize: 18),
                  prefixIcon: const Icon(Icons.attach_money, color: Colors.amber),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.amber, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El monto es obligatorio';
                  }
                  if (double.tryParse(value.trim()) == null) {
                    return 'Ingresa un número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Estado
              const Text(
                'Estado del Pago',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[700]!),
                ),
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: 20),
                          SizedBox(width: 8),
                          Text('Pagado', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      value: 'pagado',
                      groupValue: _estadoSeleccionado,
                      activeColor: Colors.amber,
                      onChanged: (value) {
                        setState(() => _estadoSeleccionado = value!);
                      },
                    ),
                    const Divider(color: Colors.white12, height: 1),
                    RadioListTile<String>(
                      title: const Row(
                        children: [
                          Icon(Icons.pending, color: Colors.orange, size: 20),
                          SizedBox(width: 8),
                          Text('Pendiente', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      value: 'pendiente',
                      groupValue: _estadoSeleccionado,
                      activeColor: Colors.amber,
                      onChanged: (value) {
                        setState(() => _estadoSeleccionado = value!);
                      },
                    ),
                    const Divider(color: Colors.white12, height: 1),
                    RadioListTile<String>(
                      title: const Row(
                        children: [
                          Icon(Icons.warning, color: Colors.red, size: 20),
                          SizedBox(width: 8),
                          Text('Moroso', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      value: 'moroso',
                      groupValue: _estadoSeleccionado,
                      activeColor: Colors.amber,
                      onChanged: (value) {
                        setState(() => _estadoSeleccionado = value!);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Fecha
              const Text(
                'Fecha de Pago',
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
                    initialDate: _fechaSeleccionada,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (fecha != null) {
                    setState(() => _fechaSeleccionada = fecha);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[700]!),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.amber),
                      const SizedBox(width: 12),
                      Text(
                        '${_fechaSeleccionada.day}/${_fechaSeleccionada.month}/${_fechaSeleccionada.year}',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Botón guardar
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: (_guardando || propiedadesAlquiladas.isEmpty)
                      ? null
                      : _guardarPago,
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
                  label: Text(_guardando ? 'Guardando...' : 'Guardar Pago'),
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
}