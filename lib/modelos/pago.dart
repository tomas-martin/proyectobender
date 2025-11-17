import 'package:cloud_firestore/cloud_firestore.dart';

class Pago {
  final String id;
  final String propiedadId;
  final String propiedadTitulo;
  final double monto;
  final String estado;
  final DateTime fecha;
  final String? comprobante;
  // ✅ SOLO PROPIETARIO (quien paga)
  final String? propietarioId;
  final String? propietarioNombre;

  Pago({
    required this.id,
    required this.propiedadId,
    required this.propiedadTitulo,
    required this.monto,
    required this.estado,
    required this.fecha,
    this.comprobante,
    this.propietarioId,
    this.propietarioNombre,
  });

  // Leer desde Firestore
  factory Pago.fromMap(String id, Map<String, dynamic> data) {
    return Pago(
      id: id,
      propiedadId: data['propiedadId']?.toString() ?? '',
      propiedadTitulo: data['propiedadTitulo']?.toString() ?? 'Sin propiedad',
      monto: (data['monto'] is int)
          ? (data['monto'] as int).toDouble()
          : (data['monto'] as double? ?? 0.0),
      estado: data['estado']?.toString() ?? 'pendiente',
      fecha: (data['fecha'] as Timestamp?)?.toDate() ?? DateTime.now(),
      comprobante: data['comprobante']?.toString(),
      propietarioId: data['propietarioId']?.toString(),
      propietarioNombre: data['propietarioNombre']?.toString(),
    );
  }

  // Guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'propiedadId': propiedadId,
      'propiedadTitulo': propiedadTitulo,
      'monto': monto,
      'estado': estado,
      'fecha': Timestamp.fromDate(fecha),
      'comprobante': comprobante,
      'propietarioId': propietarioId,
      'propietarioNombre': propietarioNombre,
    };
  }

  // Método para crear copia con cambios
  Pago copyWith({
    String? id,
    String? propiedadId,
    String? propiedadTitulo,
    double? monto,
    String? estado,
    DateTime? fecha,
    String? comprobante,
    String? propietarioId,
    String? propietarioNombre,
  }) {
    return Pago(
      id: id ?? this.id,
      propiedadId: propiedadId ?? this.propiedadId,
      propiedadTitulo: propiedadTitulo ?? this.propiedadTitulo,
      monto: monto ?? this.monto,
      estado: estado ?? this.estado,
      fecha: fecha ?? this.fecha,
      comprobante: comprobante ?? this.comprobante,
      propietarioId: propietarioId ?? this.propietarioId,
      propietarioNombre: propietarioNombre ?? this.propietarioNombre,
    );
  }

  // Helpers
  bool get estaPagado => estado == 'pagado';
  bool get estaPendiente => estado == 'pendiente';
  bool get estaMoroso => estado == 'moroso';
}