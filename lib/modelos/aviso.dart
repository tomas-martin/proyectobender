import 'package:cloud_firestore/cloud_firestore.dart';

class Aviso {
  final String id;
  final String titulo;
  final String descripcion;
  final String prioridad; // 'alta', 'media', 'baja'
  final bool leido;
  final DateTime fecha;

  Aviso({
    required this.id,
    required this.titulo,
    required this.descripcion,
    this.prioridad = 'media',
    this.leido = false,
    DateTime? fecha,
  }) : fecha = fecha ?? DateTime.now();

  factory Aviso.fromMap(String id, Map<String, dynamic> data) {
    return Aviso(
      id: id,
      titulo: data['titulo']?.toString() ?? 'Sin título',
      descripcion: data['descripcion']?.toString() ?? '',
      prioridad: data['prioridad']?.toString() ?? 'media',
      leido: data['leido'] ?? false,
      fecha: (data['fecha'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'prioridad': prioridad,
      'leido': leido,
      'fecha': Timestamp.fromDate(fecha),
    };
  }

  Aviso copyWith({
    String? id,
    String? titulo,
    String? descripcion,
    String? prioridad,
    bool? leido,
    DateTime? fecha,
  }) {
    return Aviso(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      prioridad: prioridad ?? this.prioridad,
      leido: leido ?? this.leido,
      fecha: fecha ?? this.fecha,
    );
  }

  String get fechaFormateada {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }
}