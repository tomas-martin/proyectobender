import 'package:cloud_firestore/cloud_firestore.dart';

class ReporteProblema {
  final String id;
  final String propiedadId;
  final String propiedadTitulo;
  final String titulo;
  final String descripcion;
  final String categoria; // 'mantenimiento', 'plomeria', 'electricidad', 'limpieza', 'otro'
  final String prioridad; // 'alta', 'media', 'baja'
  final String estado; // 'pendiente', 'en_proceso', 'resuelto'
  final DateTime fechaReporte;
  final DateTime? fechaResolucion;
  final String? solucion;

  ReporteProblema({
    required this.id,
    required this.propiedadId,
    required this.propiedadTitulo,
    required this.titulo,
    required this.descripcion,
    this.categoria = 'mantenimiento',
    this.prioridad = 'media',
    this.estado = 'pendiente',
    DateTime? fechaReporte,
    this.fechaResolucion,
    this.solucion,
  }) : fechaReporte = fechaReporte ?? DateTime.now();

  factory ReporteProblema.fromMap(String id, Map<String, dynamic> data) {
    return ReporteProblema(
      id: id,
      propiedadId: data['propiedadId']?.toString() ?? '',
      propiedadTitulo: data['propiedadTitulo']?.toString() ?? 'Sin propiedad',
      titulo: data['titulo']?.toString() ?? 'Sin título',
      descripcion: data['descripcion']?.toString() ?? '',
      categoria: data['categoria']?.toString() ?? 'mantenimiento',
      prioridad: data['prioridad']?.toString() ?? 'media',
      estado: data['estado']?.toString() ?? 'pendiente',
      fechaReporte: (data['fechaReporte'] as Timestamp?)?.toDate() ?? DateTime.now(),
      fechaResolucion: (data['fechaResolucion'] as Timestamp?)?.toDate(),
      solucion: data['solucion']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'propiedadId': propiedadId,
      'propiedadTitulo': propiedadTitulo,
      'titulo': titulo,
      'descripcion': descripcion,
      'categoria': categoria,
      'prioridad': prioridad,
      'estado': estado,
      'fechaReporte': Timestamp.fromDate(fechaReporte),
      'fechaResolucion': fechaResolucion != null
          ? Timestamp.fromDate(fechaResolucion!)
          : null,
      'solucion': solucion,
    };
  }

  ReporteProblema copyWith({
    String? id,
    String? propiedadId,
    String? propiedadTitulo,
    String? titulo,
    String? descripcion,
    String? categoria,
    String? prioridad,
    String? estado,
    DateTime? fechaReporte,
    DateTime? fechaResolucion,
    String? solucion,
  }) {
    return ReporteProblema(
      id: id ?? this.id,
      propiedadId: propiedadId ?? this.propiedadId,
      propiedadTitulo: propiedadTitulo ?? this.propiedadTitulo,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      categoria: categoria ?? this.categoria,
      prioridad: prioridad ?? this.prioridad,
      estado: estado ?? this.estado,
      fechaReporte: fechaReporte ?? this.fechaReporte,
      fechaResolucion: fechaResolucion ?? this.fechaResolucion,
      solucion: solucion ?? this.solucion,
    );
  }

  // Helpers
  bool get estaPendiente => estado == 'pendiente';
  bool get estaEnProceso => estado == 'en_proceso';
  bool get estaResuelto => estado == 'resuelto';

  String get fechaFormateada {
    return '${fechaReporte.day}/${fechaReporte.month}/${fechaReporte.year}';
  }
}