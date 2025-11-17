import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modelos/pago.dart';
import '../modelos/propiedad.dart';
import '../vista_modelos/pagos_vm.dart';
import '../vista_modelos/propiedades_vm.dart';

class AgregarPagoVista extends StatefulWidget {
  final Pago? pago;
  final Propiedad? propiedadPreseleccionada;
  final String? propiedadId;

  const AgregarPagoVista({
    super.key,
    this.pago,
    this.propiedadPreseleccionada,
    this.propiedadId,
  });

  @override
  State<AgregarPagoVista> createState() => _AgregarPagoVistaState();
}

class _AgregarPagoVistaState extends State<AgregarPagoVista> {
  final _formKey = GlobalKey<FormState>();
  final _montoController = TextEditingController();
  final _propietarioController = TextEditingController();

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
      _propietarioController.text = widget.pago!.propietarioNombre ?? 'Sin propietario';
    }

    if (widget.propiedadId != null && widget.propiedadPreseleccionada == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final propiedadesVM =
        Provider.of<PropiedadesViewModel>(context, listen: false);
        final prop = propiedadesVM.propiedades.firstWhere(
              (p) => p.id == widget.propiedadId,
          orElse: () => propiedadesVM.propiedades.first,
        );
        setState(() {
          _propiedadSeleccionada = prop;
          _montoController.text = prop.alquilerMensual.toString();
          _propietarioController.text = prop.propietarioNombre ?? 'Sin propietario';
        });
      });
    }
  }

  @override
  void dispose() {
    _montoController.dispose();
    _propietarioController.dispose();
    super.dispose();
  }

  Future<void> _guardarPago() async {
    if (!_formKey.currentState!.validate()) return;
    if (_propiedadSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selecciona una propiedad"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _guardando = true);

    try {
      final pagosVM = Provider.of<PagosViewModel>(context, listen: false);

      final pago = Pago(
        id: widget.pago?.id ?? "",
        propiedadId: _propiedadSeleccionada!.id,
        propiedadTitulo: _propiedadSeleccionada!.titulo,
        monto: double.parse(_montoController.text.trim()),
        estado: _estadoSeleccionado,
        fecha: _fechaSeleccionada,
        propietarioId: _propiedadSeleccionada!.propietarioId,
        propietarioNombre: _propiedadSeleccionada!.propietarioNombre,
      );

      if (widget.pago == null) {
        await pagosVM.agregar(pago);
      } else {
        await pagosVM.actualizar(widget.pago!.id, pago);
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al guardar: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  Widget _buildPropiedadItem(Propiedad prop) {
    return Row(
      children: [
        const Icon(Icons.home, color: Colors.amber, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                prop.titulo,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "${prop.propietarioNombre ?? 'Sin propietario'} • \$${prop.alquilerMensual.toStringAsFixed(0)}",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final propiedadesVM = Provider.of<PropiedadesViewModel>(context);
    final todasPropiedades = propiedadesVM.propiedades;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(widget.pago == null ? "Registrar Pago" : "Editar Pago"),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------------------- PROPIEDAD --------------------
              const Text("Propiedad",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(height: 8),

              if (todasPropiedades.isEmpty)
                const Text("No hay propiedades registradas",
                    style: TextStyle(color: Colors.orange))
              else
                DropdownButtonFormField<Propiedad>(
                  value: _propiedadSeleccionada,
                  dropdownColor: const Color(0xFF1E1E1E),
                  isExpanded: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.amber),
                  selectedItemBuilder: (context) {
                    return todasPropiedades.map((prop) {
                      return Row(
                        children: [
                          const Icon(Icons.home, color: Colors.amber, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              prop.titulo,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      );
                    }).toList();
                  },
                  items: todasPropiedades.map((prop) {
                    return DropdownMenuItem(
                      value: prop,
                      child: _buildPropiedadItem(prop),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _propiedadSeleccionada = value;
                      if (value != null) {
                        _montoController.text = value.alquilerMensual.toString();
                        _propietarioController.text = value.propietarioNombre ?? 'Sin propietario';
                      }
                    });
                  },
                ),

              const SizedBox(height: 20),

              // -------------------- PROPIETARIO (READ-ONLY) --------------------
              const Text("Propietario (quien paga)",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(height: 8),

              TextFormField(
                controller: _propietarioController,
                style: const TextStyle(color: Colors.white70),
                enabled: false,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person, color: Colors.purple),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.03),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "Selecciona una propiedad primero",
                  hintStyle: const TextStyle(color: Colors.white38),
                ),
              ),

              const SizedBox(height: 20),

              // -------------------- MONTO --------------------
              const Text("Monto",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(height: 8),

              TextFormField(
                controller: _montoController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon:
                  const Icon(Icons.attach_money, color: Colors.amber),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "Ej: 15000",
                  hintStyle: const TextStyle(color: Colors.white38),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Obligatorio";
                  if (double.tryParse(v) == null) return "Número inválido";
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // -------------------- ESTADO --------------------
              const Text("Estado del Pago",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    RadioListTile(
                      title: const Text("Pagado",
                          style: TextStyle(color: Colors.white)),
                      value: "pagado",
                      groupValue: _estadoSeleccionado,
                      onChanged: (v) => setState(() => _estadoSeleccionado = v!),
                    ),
                    RadioListTile(
                      title: const Text("Pendiente",
                          style: TextStyle(color: Colors.white)),
                      value: "pendiente",
                      groupValue: _estadoSeleccionado,
                      onChanged: (v) => setState(() => _estadoSeleccionado = v!),
                    ),
                    RadioListTile(
                      title: const Text("Moroso",
                          style: TextStyle(color: Colors.white)),
                      value: "moroso",
                      groupValue: _estadoSeleccionado,
                      onChanged: (v) => setState(() => _estadoSeleccionado = v!),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // -------------------- FECHA --------------------
              const Text("Fecha de Pago",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(height: 8),

              InkWell(
                onTap: () async {
                  final fecha = await showDatePicker(
                    context: context,
                    initialDate: _fechaSeleccionada,
                    firstDate: DateTime(2020),
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
                    setState(() => _fechaSeleccionada = fecha);
                  }
                },
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.amber),
                      const SizedBox(width: 12),
                      Text(
                        "${_fechaSeleccionada.day}/${_fechaSeleccionada.month}/${_fechaSeleccionada.year}",
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // -------------------- BOTÓN --------------------
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  icon: _guardando
                      ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.black, strokeWidth: 2))
                      : const Icon(Icons.save),
                  label: Text(_guardando ? "Guardando..." : "Guardar Pago"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _guardando || todasPropiedades.isEmpty
                      ? null
                      : _guardarPago,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}