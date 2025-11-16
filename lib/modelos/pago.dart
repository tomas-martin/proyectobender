import 'package:cloud_firestore/cloud_firestore.dart';

class Pago {
  final String id;
  final String propiedadId; // 🔗 Conexión con Propiedad
  final String propiedadTitulo; // Para mostrar en la UI
  final String inquilinoId;
  final String inquilinoNombre;
  final double monto;
  final String estado; // 'pagado', 'pendiente', 'moroso'
  final DateTime fecha;
  final String? comprobante; // URL de imagen de comprobante (opcional)

  Pago({
    required this.id,
    required this.propiedadId,
    required this.propiedadTitulo,
    required this.inquilinoId,
    required this.inquilinoNombre,
    required this.monto,
    required this.estado,
    required this.fecha,
    this.comprobante,
  });

  // Leer desde Firestore
  factory Pago.fromMap(String id, Map<String, dynamic> data) {
    return Pago(
      id: id,
      propiedadId: data['propiedadId']?.toString() ?? '',
      propiedadTitulo: data['propiedadTitulo']?.toString() ?? 'Sin propiedad',
      inquilinoId: data['inquilinoId']?.toString() ?? '',
      inquilinoNombre: data['inquilinoNombre']?.toString() ?? 'Sin nombre',
      monto: (data['monto'] is int)
          ? (data['monto'] as int).toDouble()
          : (data['monto'] as double? ?? 0.0),
      estado: data['estado']?.toString() ?? 'pendiente',
      fecha: (data['fecha'] as Timestamp?)?.toDate() ?? DateTime.now(),
      comprobante: data['comprobante']?.toString(),
    );
  }

  // Guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'propiedadId': propiedadId,
      'propiedadTitulo': propiedadTitulo,
      'inquilinoId': inquilinoId,
      'inquilinoNombre': inquilinoNombre,
      'monto': monto,
      'estado': estado,
      'fecha': Timestamp.fromDate(fecha),
      'comprobante': comprobante,
    };
  }

  // Método para crear copia con cambios
  Pago copyWith({
    String? id,
    String? propiedadId,
    String? propiedadTitulo,
    String? inquilinoId,
    String? inquilinoNombre,
    double? monto,
    String? estado,
    DateTime? fecha,
    String? comprobante,
  }) {
    return Pago(
      id: id ?? this.id,
      propiedadId: propiedadId ?? this.propiedadId,
      propiedadTitulo: propiedadTitulo ?? this.propiedadTitulo,
      inquilinoId: inquilinoId ?? this.inquilinoId,
      inquilinoNombre: inquilinoNombre ?? this.inquilinoNombre,
      monto: monto ?? this.monto,
      estado: estado ?? this.estado,
      fecha: fecha ?? this.fecha,
      comprobante: comprobante ?? this.comprobante,
    );
  }

  // Helpers
  bool get estaPagado => estado == 'pagado';
  bool get estaPendiente => estado == 'pendiente';
  bool get estaMoroso => estado == 'moroso';
}