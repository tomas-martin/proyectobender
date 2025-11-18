import 'package:cloud_firestore/cloud_firestore.dart';

class RecordatorioPago {
  final String id;
  final String propiedadId;
  final String propiedadTitulo;
  final String propietarioId;
  final String propietarioNombre;
  final double monto;
  final DateTime fechaVencimiento;
  final String estado; // 'pendiente', 'enviado', 'pagado'
  final bool notificado;
  final DateTime? fechaNotificacion;

  // 🆕 Campos nuevos para vinculación automática
  final String? pagoId; // ID del pago asociado
  final bool generadoAutomaticamente; // Si fue generado automáticamente

  RecordatorioPago({
    required this.id,
    required this.propiedadId,
    required this.propiedadTitulo,
    required this.propietarioId,
    required this.propietarioNombre,
    required this.monto,
    required this.fechaVencimiento,
    this.estado = 'pendiente',
    this.notificado = false,
    this.fechaNotificacion,
    this.pagoId, // 🆕
    this.generadoAutomaticamente = false, // 🆕
  });

  factory RecordatorioPago.fromMap(String id, Map<String, dynamic> data) {
    return RecordatorioPago(
      id: id,
      propiedadId: data['propiedadId']?.toString() ?? '',
      propiedadTitulo: data['propiedadTitulo']?.toString() ?? 'Sin propiedad',
      propietarioId: data['propietarioId']?.toString() ?? '',
      propietarioNombre: data['propietarioNombre']?.toString() ?? 'Sin propietario',
      monto: (data['monto'] is int)
          ? (data['monto'] as int).toDouble()
          : (data['monto'] as double? ?? 0.0),
      fechaVencimiento: (data['fechaVencimiento'] as Timestamp?)?.toDate() ?? DateTime.now(),
      estado: data['estado']?.toString() ?? 'pendiente',
      notificado: data['notificado'] ?? false,
      fechaNotificacion: (data['fechaNotificacion'] as Timestamp?)?.toDate(),
      pagoId: data['pagoId']?.toString(), // 🆕
      generadoAutomaticamente: data['generadoAutomaticamente'] ?? false, // 🆕
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'propiedadId': propiedadId,
      'propiedadTitulo': propiedadTitulo,
      'propietarioId': propietarioId,
      'propietarioNombre': propietarioNombre,
      'monto': monto,
      'fechaVencimiento': Timestamp.fromDate(fechaVencimiento),
      'estado': estado,
      'notificado': notificado,
      'fechaNotificacion': fechaNotificacion != null
          ? Timestamp.fromDate(fechaNotificacion!)
          : null,
      'pagoId': pagoId, // 🆕
      'generadoAutomaticamente': generadoAutomaticamente, // 🆕
    };
  }

  RecordatorioPago copyWith({
    String? id,
    String? propiedadId,
    String? propiedadTitulo,
    String? propietarioId,
    String? propietarioNombre,
    double? monto,
    DateTime? fechaVencimiento,
    String? estado,
    bool? notificado,
    DateTime? fechaNotificacion,
    String? pagoId,
    bool? generadoAutomaticamente,
  }) {
    return RecordatorioPago(
      id: id ?? this.id,
      propiedadId: propiedadId ?? this.propiedadId,
      propiedadTitulo: propiedadTitulo ?? this.propiedadTitulo,
      propietarioId: propietarioId ?? this.propietarioId,
      propietarioNombre: propietarioNombre ?? this.propietarioNombre,
      monto: monto ?? this.monto,
      fechaVencimiento: fechaVencimiento ?? this.fechaVencimiento,
      estado: estado ?? this.estado,
      notificado: notificado ?? this.notificado,
      fechaNotificacion: fechaNotificacion ?? this.fechaNotificacion,
      pagoId: pagoId ?? this.pagoId, // 🆕
      generadoAutomaticamente: generadoAutomaticamente ?? this.generadoAutomaticamente, // 🆕
    );
  }

  // Helpers
  bool get estaPendiente => estado == 'pendiente';
  bool get estaEnviado => estado == 'enviado';
  bool get estaPagado => estado == 'pagado';

  bool get estaVencido {
    final ahora = DateTime.now();
    return fechaVencimiento.isBefore(ahora) && !estaPagado;
  }

  bool get estaProximo {
    final ahora = DateTime.now();
    final diferencia = fechaVencimiento.difference(ahora).inDays;
    return diferencia >= 0 && diferencia <= 7 && !estaPagado;
  }

  int get diasHastaVencimiento {
    final ahora = DateTime.now();
    return fechaVencimiento.difference(ahora).inDays;
  }

  String get fechaFormateada {
    return '${fechaVencimiento.day}/${fechaVencimiento.month}/${fechaVencimiento.year}';
  }
}