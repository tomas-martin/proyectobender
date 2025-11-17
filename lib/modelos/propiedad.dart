class Propiedad {
  final String id;
  final String titulo;
  final String direccion;
  final double alquilerMensual;
  final String imagen;
  final String estado; // 'disponible' o 'alquilada'

  // 🔵 Inquilino
  final String? inquilinoId;
  final String? inquilinoNombre;

  // 🔵 Propietario (AGREGADO)
  final String? propietarioId;
  final String? propietarioNombre;

  final String tipo;
  final String fechaRegistro;

  Propiedad({
    required this.id,
    required this.titulo,
    required this.direccion,
    required this.alquilerMensual,
    required this.imagen,
    this.estado = 'disponible',
    this.inquilinoId,
    this.inquilinoNombre,

    // 🔵 Propietario (AGREGADO)
    this.propietarioId,
    this.propietarioNombre,

    this.tipo = 'Departamento',
    String? fechaRegistro,
  }) : fechaRegistro = fechaRegistro ?? _getFechaActual();

  // 🔶 Helper para obtener fecha actual formateada
  static String _getFechaActual() {
    final now = DateTime.now();
    return '${now.day}/${now.month}/${now.year}';
  }

  // 🔶 Leer desde Firestore
  factory Propiedad.fromMap(String id, Map<String, dynamic> data) {
    double alquiler = 0.0;
    final alquilerData = data['alquilerMensual'];

    if (alquilerData is int) alquiler = alquilerData.toDouble();
    else if (alquilerData is double) alquiler = alquilerData;
    else if (alquilerData is String) alquiler = double.tryParse(alquilerData) ?? 0.0;

    String fechaRegistro = _getFechaActual();
    if (data['createdAt'] != null) {
      try {
        final timestamp = data['createdAt'];
        final date = timestamp is DateTime ? timestamp : timestamp.toDate();
        fechaRegistro = '${date.day}/${date.month}/${date.year}';
      } catch (_) {}
    }

    return Propiedad(
      id: id,
      titulo: data['titulo']?.toString() ?? 'Sin título',
      direccion: data['direccion']?.toString() ?? 'Sin dirección',
      alquilerMensual: alquiler,
      imagen: data['imagen']?.toString() ?? '',
      estado: data['estado']?.toString() ?? 'disponible',

      // 🔵 Inquilino
      inquilinoId: data['inquilinoId']?.toString(),
      inquilinoNombre: data['inquilinoNombre']?.toString(),

      // 🔵 Propietario (AGREGADO)
      propietarioId: data['propietarioId']?.toString(),
      propietarioNombre: data['propietarioNombre']?.toString(),

      tipo: data['tipo']?.toString() ?? 'Departamento',
      fechaRegistro: fechaRegistro,
    );
  }

  // 🔶 Guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'direccion': direccion,
      'alquilerMensual': alquilerMensual,
      'imagen': imagen,
      'estado': estado,

      // 🔵 Inquilino
      'inquilinoId': inquilinoId,
      'inquilinoNombre': inquilinoNombre,

      // 🔵 Propietario (AGREGADO)
      'propietarioId': propietarioId,
      'propietarioNombre': propietarioNombre,

      'tipo': tipo,
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

    // 🔵 Inquilino
    String? inquilinoId,
    String? inquilinoNombre,

    // 🔵 Propietario (AGREGADO)
    String? propietarioId,
    String? propietarioNombre,

    String? tipo,
    String? fechaRegistro,
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

      propietarioId: propietarioId ?? this.propietarioId,
      propietarioNombre: propietarioNombre ?? this.propietarioNombre,

      tipo: tipo ?? this.tipo,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
    );
  }
}
