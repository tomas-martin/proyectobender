import 'package:cloud_firestore/cloud_firestore.dart';

class RecordatoriosServicio {
  final CollectionReference recordatoriosRef =
  FirebaseFirestore.instance.collection('recordatorios');

  /// Obtener recordatorios en tiempo real
  Stream<QuerySnapshot> obtenerRecordatorios() {
    return recordatoriosRef
        .orderBy('fechaVencimiento', descending: false)
        .snapshots();
  }

  /// Agregar nuevo recordatorio
  Future<void> agregarRecordatorio(Map<String, dynamic> data) async {
    await recordatoriosRef.add(data);
  }

  /// Actualizar recordatorio existente
  Future<void> actualizarRecordatorio(String id, Map<String, dynamic> data) async {
    await recordatoriosRef.doc(id).update(data);
  }

  /// Eliminar recordatorio
  Future<void> borrarRecordatorio(String id) async {
    await recordatoriosRef.doc(id).delete();
  }

  /// Marcar recordatorio como enviado
  Future<void> marcarComoEnviado(String id) async {
    await recordatoriosRef.doc(id).update({
      'estado': 'enviado',
      'notificado': true,
      'fechaNotificacion': FieldValue.serverTimestamp(),
    });
  }

  /// Obtener recordatorios vencidos
  Future<List<QueryDocumentSnapshot>> obtenerRecordatoriosVencidos() async {
    final ahora = DateTime.now();
    final snapshot = await recordatoriosRef
        .where('fechaVencimiento', isLessThan: Timestamp.fromDate(ahora))
        .where('estado', isNotEqualTo: 'pagado')
        .get();

    return snapshot.docs;
  }

  /// Obtener recordatorios próximos (próximos 7 días)
  Future<List<QueryDocumentSnapshot>> obtenerRecordatoriosProximos() async {
    final ahora = DateTime.now();
    final proximaSemana = ahora.add(const Duration(days: 7));

    final snapshot = await recordatoriosRef
        .where('fechaVencimiento', isGreaterThanOrEqualTo: Timestamp.fromDate(ahora))
        .where('fechaVencimiento', isLessThanOrEqualTo: Timestamp.fromDate(proximaSemana))
        .where('estado', isNotEqualTo: 'pagado')
        .get();

    return snapshot.docs;
  }

  /// Obtener recordatorios de una propiedad específica
  Stream<QuerySnapshot> obtenerRecordatoriosPorPropiedad(String propiedadId) {
    return recordatoriosRef
        .where('propiedadId', isEqualTo: propiedadId)
        .orderBy('fechaVencimiento', descending: true)
        .snapshots();
  }
}