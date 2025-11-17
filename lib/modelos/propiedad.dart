class Propiedad {
  final String id;
  final String titulo;
  final String direccion;
  final double alquilerMensual;
  final String imagen;
  final String estado; // 'disponible' o 'alquilada'
  final String? inquilinoId;
  final String? inquilinoNombre;
  final String tipo;
  final String fechaRegistro;

  // ✅ NUEVO: Propietario
  final String? propietarioId;
  final String? propietarioNombre;

  Propiedad({
    required this.id,
    required this.titulo,
    required this.direccion,
    required this.alquilerMensual,
    required this.imagen,
    this.estado = 'disponible',
    this.inquilinoId,
    this.inquilinoNombre,
    this.tipo = 'Departamento',
    String? fechaRegistro,
    this.propietarioId,
    this.propietarioNombre,
  }) : fechaRegistro = fechaRegistro ?? _getFechaActual();

  static String _getFechaActual() {
    final now = DateTime.now();
    return '${now.day}/${now.month}/${now.year}';
  }

  factory Propiedad.fromMap(String id, Map<String, dynamic> data) {
    double alquiler = 0.0;
    final alquilerData = data['alquilerMensual'];

    if (alquilerData is int) {
      alquiler = alquilerData.toDouble();
    } else if (alquilerData is double) {
      alquiler = alquilerData;
    } else if (alquilerData is String) {
      alquiler = double.tryParse(alquilerData) ?? 0.0;
    }

    String fechaRegistro = _getFechaActual();
    if (data['createdAt'] != null) {
      try {
        final timestamp = data['createdAt'];
        if (timestamp is DateTime) {
          fechaRegistro = '${timestamp.day}/${timestamp.month}/${timestamp.year}';
        } else {
          final date = timestamp.toDate();
          fechaRegistro = '${date.day}/${date.month}/${date.year}';
        }
      } catch (e) {
        fechaRegistro = _getFechaActual();
      }
    }

    return Propiedad(
      id: id,
      titulo: data['titulo']?.toString() ?? 'Sin título',
      direccion: data['direccion']?.toString() ?? 'Sin dirección',
      alquilerMensual: alquiler,
      imagen: data['imagen']?.toString() ?? '',
      estado: data['estado']?.toString() ?? 'disponible',
      inquilinoId: data['inquilinoId']?.toString(),
      inquilinoNombre: data['inquilinoNombre']?.toString(),
      tipo: data['tipo']?.toString() ?? 'Departamento',
      fechaRegistro: fechaRegistro,
      propietarioId: data['propietarioId']?.toString(),
      propietarioNombre: data['propietarioNombre']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'direccion': direccion,
      'alquilerMensual': alquilerMensual,
      'imagen': imagen,
      'estado': estado,
      'inquilinoId': inquilinoId,
      'inquilinoNombre': inquilinoNombre,
      'tipo': tipo,
      'propietarioId': propietarioId,
      'propietarioNombre': propietarioNombre,
    };
  }

  bool get estaAlquilada => estado == 'alquilada';

  Propiedad copyWith({
    String? id,
    String? titulo,
    String? direccion,
    double? alquilerMensual,
    String? imagen,
    String? estado,
    String? inquilinoId,
    String? inquilinoNombre,
    String? tipo,
    String? fechaRegistro,
    String? propietarioId,
    String? propietarioNombre,
  }) {
    return Propiedad(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      direccion: direccion ?? this.direccion,
      alquilerMensual: alquilerMensual ?? this.alquilerMensual,
      imagen: imagen ?? this.imagen,
      estado: estado ?? this.estado,
      inquilinoId: inquilinoId ?? this.inquilinoId,
      inquilinoNombre: inquilinoNombre ?? this.inquilinoNombre,
      tipo: tipo ?? this.tipo,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
      propietarioId: propietarioId ?? this.propietarioId,
      propietarioNombre: propietarioNombre ?? this.propietarioNombre,
    );
  }
}