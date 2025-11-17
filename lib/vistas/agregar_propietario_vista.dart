import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modelos/propietario.dart';
import '../vista_modelos/propietarios_vm.dart';

class AgregarPropietarioVista extends StatefulWidget {
  final Propietario? propietario;

  const AgregarPropietarioVista({super.key, this.propietario});

  @override
  State<AgregarPropietarioVista> createState() => _AgregarPropietarioVistaState();
}

class _AgregarPropietarioVistaState extends State<AgregarPropietarioVista> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();
  final _direccionController = TextEditingController();
  final _notasController = TextEditingController();

  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    if (widget.propietario != null) {
      _nombreController.text = widget.propietario!.nombre;
      _telefonoController.text = widget.propietario!.telefono;
      _emailController.text = widget.propietario!.email;
      _direccionController.text = widget.propietario!.direccion ?? '';
      _notasController.text = widget.propietario!.notas ?? '';
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _direccionController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    try {
      final vm = Provider.of<PropietariosViewModel>(context, listen: false);

      final propietario = Propietario(
        id: widget.propietario?.id ?? '',
        nombre: _nombreController.text.trim(),
        telefono: _telefonoController.text.trim(),
        email: _emailController.text.trim(),
        direccion: _direccionController.text.trim().isEmpty ? null : _direccionController.text.trim(),
        notas: _notasController.text.trim().isEmpty ? null : _notasController.text.trim(),
      );

      if (widget.propietario == null) {
        await vm.agregar(propietario);
      } else {
        await vm.actualizar(widget.propietario!.id, propietario);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.propietario == null
                ? '✅ Propietario agregado'
                : '✅ Propietario actualizado'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(widget.propietario == null ? 'Nuevo Propietario' : 'Editar Propietario'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre
              _buildCampo(
                'Nombre Completo',
                _nombreController,
                Icons.person,
                'Ej: Juan Pérez',
                obligatorio: true,
              ),
              const SizedBox(height: 20),

              // Teléfono
              _buildCampo(
                'Teléfono',
                _telefonoController,
                Icons.phone,
                'Ej: +54 261 123-4567',
                tipo: TextInputType.phone,
                obligatorio: true,
              ),
              const SizedBox(height: 20),

              // Email
              _buildCampo(
                'Email',
                _emailController,
                Icons.email,
                'Ej: juan@example.com',
                tipo: TextInputType.emailAddress,
                obligatorio: true,
                validarEmail: true,
              ),
              const SizedBox(height: 20),

              // Dirección (opcional)
              _buildCampo(
                'Dirección (Opcional)',
                _direccionController,
                Icons.location_on,
                'Ej: Av. San Martín 123',
              ),
              const SizedBox(height: 20),

              // Notas (opcional)
              const Text(
                'Notas (Opcional)',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notasController,
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Información adicional...',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: const Icon(Icons.notes, color: Colors.amber),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.amber, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Botón guardar
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _guardando ? null : _guardar,
                  icon: _guardando
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                  )
                      : const Icon(Icons.save),
                  label: Text(_guardando ? 'Guardando...' : 'Guardar Propietario'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCampo(
      String label,
      TextEditingController controller,
      IconData icon,
      String hint, {
        TextInputType tipo = TextInputType.text,
        bool obligatorio = false,
        bool validarEmail = false,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          keyboardType: tipo,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[600]),
            prefixIcon: Icon(icon, color: Colors.amber),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.amber, width: 2),
            ),
          ),
          validator: (value) {
            if (obligatorio && (value == null || value.trim().isEmpty)) {
              return 'Este campo es obligatorio';
            }
            if (validarEmail && value != null && value.isNotEmpty) {
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value)) {
                return 'Email inválido';
              }
            }
            return null;
          },
        ),
      ],
    );
  }
}