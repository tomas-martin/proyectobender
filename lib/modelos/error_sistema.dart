import 'package:cloud_firestore/cloud_firestore.dart';

class ErrorSistema {
  final String id;
  final String titulo;
  final String descripcion;
  final String tipo; // 'critico', 'advertencia', 'info'
  final bool resuelto;
  final DateTime fecha;
  final String? solucion;

  ErrorSistema({
    required this.id,
    required this.titulo,
    required this.descripcion,
    this.tipo = 'advertencia',
    this.resuelto = false,
    DateTime? fecha,
    this.solucion,
  }) : fecha = fecha ?? DateTime.now();

  factory ErrorSistema.fromMap(String id, Map<String, dynamic> data) {
    return ErrorSistema(
      id: id,
      titulo: data['titulo']?.toString() ?? 'Sin título',
      descripcion: data['descripcion']?.toString() ?? '',
      tipo: data['tipo']?.toString() ?? 'advertencia',
      resuelto: data['resuelto'] ?? false,
      fecha: (data['fecha'] as Timestamp?)?.toDate() ?? DateTime.now(),
      solucion: data['solucion']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'tipo': tipo,
      'resuelto': resuelto,
      'fecha': Timestamp.fromDate(fecha),
      'solucion': solucion,
    };
  }

  ErrorSistema copyWith({
    String? id,
    String? titulo,
    String? descripcion,
    String? tipo,
    bool? resuelto,
    DateTime? fecha,
    String? solucion,
  }) {
    return ErrorSistema(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      tipo: tipo ?? this.tipo,
      resuelto: resuelto ?? this.resuelto,
      fecha: fecha ?? this.fecha,
      solucion: solucion ?? this.solucion,
    );
  }

  String get fechaFormateada {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }
}