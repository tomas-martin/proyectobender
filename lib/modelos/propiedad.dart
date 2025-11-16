class Propiedad {
  final String id;
  final String titulo;
  final String direccion;
  final double alquilerMensual;
  final String imagen;
  final String estado; // 'disponible' o 'alquilada'
  final String? inquilinoId; // ID del inquilino (null si está disponible)
  final String? inquilinoNombre; // Nombre del inquilino

  Propiedad({
    required this.id,
    required this.titulo,
    required this.direccion,
    required this.alquilerMensual,
    required this.imagen,
    this.estado = 'disponible',
    this.inquilinoId,
    this.inquilinoNombre,
  });

  // Para leer desde Firestore
  factory Propiedad.fromMap(String id, Map<String, dynamic> data) {
    // Conversión segura de número a double
    double alquiler = 0.0;
    final alquilerData = data['alquilerMensual'];

    if (alquilerData is int) {
      alquiler = alquilerData.toDouble();
    } else if (alquilerData is double) {
      alquiler = alquilerData;
    } else if (alquilerData is String) {
      alquiler = double.tryParse(alquilerData) ?? 0.0;
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
    );
  }

  // Para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'direccion': direccion,
      'alquilerMensual': alquilerMensual,
      'imagen': imagen,
      'estado': estado,
      'inquilinoId': inquilinoId,
      'inquilinoNombre': inquilinoNombre,
    };
  }

  // Método helper para verificar si está alquilada
  bool get estaAlquilada => estado == 'alquilada';

  // Método para crear copia con cambios
  Propiedad copyWith({
    String? id,
    String? titulo,
    String? direccion,
    double? alquilerMensual,
    String? imagen,
    String? estado,
    String? inquilinoId,
    String? inquilinoNombre,
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
    );
  }
}