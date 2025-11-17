import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../modelos/propiedad.dart';
import '../vista_modelos/propiedades_vm.dart';
import '../servicios/storage_servicio.dart';

class AgregarPropiedadVista extends StatefulWidget {
  final Propiedad? propiedad;

  const AgregarPropiedadVista({super.key, this.propiedad});

  @override
  State<AgregarPropiedadVista> createState() => _AgregarPropiedadVistaState();
}

class _AgregarPropiedadVistaState extends State<AgregarPropiedadVista> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _direccionController = TextEditingController();
  final _alquilerController = TextEditingController();
  final _imagenUrlController = TextEditingController();

  // 🔥 LO QUE TE FALTABA:
  String _estadoSeleccionado = 'disponible';
  final TextEditingController _inquilinoController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _imagenSeleccionada;
  bool _guardando = false;
  bool _subiendoImagen = false;

  @override
  void initState() {
    super.initState();
    if (widget.propiedad != null) {
      _tituloController.text = widget.propiedad!.titulo;
      _direccionController.text = widget.propiedad!.direccion;
      _alquilerController.text = widget.propiedad!.alquilerMensual.toString();
      _imagenUrlController.text = widget.propiedad!.imagen;
      _estadoSeleccionado = widget.propiedad!.estado;
      _inquilinoController.text = widget.propiedad!.inquilinoNombre ?? '';
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _direccionController.dispose();
    _alquilerController.dispose();
    _imagenUrlController.dispose();
    _inquilinoController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarImagen() async {
    try {
      final XFile? imagen = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (imagen != null) {
        setState(() {
          _imagenSeleccionada = File(imagen.path);
          _imagenUrlController.clear();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al seleccionar imagen: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<String?> _subirImagenSiEsNecesario() async {
    if (_imagenSeleccionada != null) {
      setState(() => _subiendoImagen = true);

      final storageService = StorageServicio();

      if (widget.propiedad != null && widget.propiedad!.imagen.isNotEmpty) {
        await storageService.eliminarImagen(widget.propiedad!.imagen);
      }

      final url = await storageService.subirImagen(_imagenSeleccionada!, 'propiedades');

      setState(() => _subiendoImagen = false);
      return url;
    }

    if (_imagenUrlController.text.trim().isNotEmpty) {
      return _imagenUrlController.text.trim();
    }

    if (widget.propiedad != null) {
      return widget.propiedad!.imagen;
    }

    return '';
  }

  Future<void> _guardarPropiedad() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    try {
      final vm = Provider.of<PropiedadesViewModel>(context, listen: false);

      final imagenUrl = await _subirImagenSiEsNecesario();

      final propiedad = Propiedad(
        id: widget.propiedad?.id ?? '',
        titulo: _tituloController.text.trim(),
        direccion: _direccionController.text.trim(),
        alquilerMensual: double.parse(_alquilerController.text.trim()),
        imagen: imagenUrl ?? '',
        estado: _estadoSeleccionado,
        inquilinoNombre: _estadoSeleccionado == 'alquilada'
            ? _inquilinoController.text.trim()
            : null,
        inquilinoId: _estadoSeleccionado == 'alquilada'
            ? 'INQ_${DateTime.now().millisecondsSinceEpoch}'
            : null,
      );

      if (widget.propiedad == null) {
        await vm.agregar(propiedad);
      } else {
        await vm.actualizar(widget.propiedad!.id, propiedad);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.propiedad == null
                ? '✅ Propiedad agregada correctamente'
                : '✅ Propiedad actualizada correctamente'),
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(widget.propiedad == null
            ? 'Nueva Propiedad'
            : 'Editar Propiedad'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildVistaPrevia(),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _guardando ? null : _seleccionarImagen,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Galería'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.amber,
                        side: const BorderSide(color: Colors.amber),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _guardando ? null : () {
                        setState(() => _imagenSeleccionada = null);
                      },
                      icon: const Icon(Icons.clear),
                      label: const Text('Limpiar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white54,
                        side: BorderSide(color: Colors.grey[700]!),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              const Text(
                'O pega una URL de imagen',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _imagenUrlController,
                style: const TextStyle(color: Colors.white),
                enabled: _imagenSeleccionada == null,
                decoration: InputDecoration(
                  hintText: 'https://ejemplo.com/imagen.jpg',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _buildCampoTexto('Título', _tituloController, 'Ej: Depto Fry', Icons.title),
              const SizedBox(height: 20),

              _buildCampoTexto('Dirección', _direccionController, 'Ej: Calle Futuro 101', Icons.location_on),
              const SizedBox(height: 20),

              const Text(
                'Alquiler Mensual',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _alquilerController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Ej: 1200',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixText: '\$ ',
                  prefixStyle: const TextStyle(color: Colors.amber, fontSize: 18),
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
                    return 'El alquiler es obligatorio';
                  }
                  if (double.tryParse(value.trim()) == null) {
                    return 'Ingresa un número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              const Text(
                'Estado de la Propiedad',
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
                          Text('Disponible', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      value: 'disponible',
                      groupValue: _estadoSeleccionado,
                      activeColor: Colors.amber,
                      onChanged: (value) {
                        setState(() {
                          _estadoSeleccionado = value!;
                          if (value == 'disponible') {
                            _inquilinoController.clear();
                          }
                        });
                      },
                    ),

                    const Divider(color: Colors.white12, height: 1),

                    RadioListTile<String>(
                      title: const Row(
                        children: [
                          Icon(Icons.home, color: Colors.blue, size: 20),
                          SizedBox(width: 8),
                          Text('Alquilada', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      value: 'alquilada',
                      groupValue: _estadoSeleccionado,
                      activeColor: Colors.amber,
                      onChanged: (value) {
                        setState(() {
                          _estadoSeleccionado = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              if (_estadoSeleccionado == 'alquilada') ...[
                const Text(
                  'Nombre del Inquilino',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                TextFormField(
                  controller: _inquilinoController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Ej: Philip J. Fry',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    prefixIcon: const Icon(Icons.person, color: Colors.amber),
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
                    if (_estadoSeleccionado == 'alquilada' &&
                        (value == null || value.trim().isEmpty)) {
                      return 'El nombre del inquilino es obligatorio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
              ],

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: (_guardando || _subiendoImagen) ? null : _guardarPropiedad,
                  icon: (_guardando || _subiendoImagen)
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
                    _subiendoImagen
                        ? 'Subiendo imagen...'
                        : _guardando
                        ? 'Guardando...'
                        : 'Guardar Propiedad',
                  ),
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

  Widget _buildVistaPrevia() {
    Widget contenido;

    if (_imagenSeleccionada != null) {
      contenido = Image.file(
        _imagenSeleccionada!,
        fit: BoxFit.cover,
      );
    } else if (_imagenUrlController.text.isNotEmpty) {
      contenido = Image.network(
        _imagenUrlController.text,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image, size: 64, color: Colors.white38),
                SizedBox(height: 8),
                Text('URL inválida', style: TextStyle(color: Colors.white38)),
              ],
            ),
          );
        },
      );
    } else {
      contenido = const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, size: 64, color: Colors.white38),
            SizedBox(height: 8),
            Text('Sin imagen', style: TextStyle(color: Colors.white38)),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[800],
      ),
      clipBehavior: Clip.hardEdge,
      child: contenido,
    );
  }

  Widget _buildCampoTexto(
      String label,
      TextEditingController controller,
      String hint,
      IconData icono,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[600]),
            prefixIcon: Icon(icono, color: Colors.amber),
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
              return '$label es obligatorio';
            }
            return null;
          },
        ),
      ],
    );
  }
}
