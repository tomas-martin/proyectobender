class Propiedad {
  final String id;
  final String titulo;
  final String direccion;
  final double alquilerMensual;
  final String imagen;

  Propiedad({
    required this.id,
    required this.titulo,
    required this.direccion,
    required this.alquilerMensual,
    required this.imagen,
  });

  // Para leer desde Firestore
  factory Propiedad.fromMap(String id, Map<String, dynamic> data) {
    return Propiedad(
      id: id,
      titulo: data['titulo'] ?? '',
      direccion: data['direccion'] ?? '',
      alquilerMensual: (data['alquilerMensual'] ?? 0).toDouble(),
      imagen: data['imagen'] ?? '',
    );
  }

  // Para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'direccion': direccion,
      'alquilerMensual': alquilerMensual,
      'imagen': imagen,
    };
  }
}
