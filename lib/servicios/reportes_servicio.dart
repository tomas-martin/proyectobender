import 'package:cloud_firestore/cloud_firestore.dart';

class ReportesServicio {
  final CollectionReference reportesRef =
  FirebaseFirestore.instance.collection('reportes');

  /// Obtener reportes en tiempo real
  Stream<QuerySnapshot> obtenerReportes() {
    return reportesRef
        .orderBy('fechaReporte', descending: true)
        .snapshots();
  }

  /// Agregar nuevo reporte
  Future<void> agregarReporte(Map<String, dynamic> data) async {
    data['fechaReporte'] = FieldValue.serverTimestamp();
    await reportesRef.add(data);
  }

  /// Actualizar reporte existente
  Future<void> actualizarReporte(String id, Map<String, dynamic> data) async {
    await reportesRef.doc(id).update(data);
  }

  /// Eliminar reporte
  Future<void> borrarReporte(String id) async {
    await reportesRef.doc(id).delete();
  }

  /// Marcar reporte como resuelto
  Future<void> marcarComoResuelto(String id, String solucion) async {
    await reportesRef.doc(id).update({
      'estado': 'resuelto',
      'resuelto': true,
      'solucion': solucion,
      'fechaResolucion': FieldValue.serverTimestamp(),
    });
  }

  /// Cambiar estado del reporte
  Future<void> cambiarEstado(String id, String nuevoEstado) async {
    await reportesRef.doc(id).update({
      'estado': nuevoEstado,
    });
  }

  /// Obtener reportes pendientes
  Future<List<QueryDocumentSnapshot>> obtenerReportesPendientes() async {
    final snapshot = await reportesRef
        .where('estado', isEqualTo: 'pendiente')
        .orderBy('fechaReporte', descending: true)
        .get();

    return snapshot.docs;
  }

  /// Obtener reportes por propiedad
  Stream<QuerySnapshot> obtenerReportesPorPropiedad(String propiedadId) {
    return reportesRef
        .where('propiedadId', isEqualTo: propiedadId)
        .orderBy('fechaReporte', descending: true)
        .snapshots();
  }

  /// Obtener reportes por categoría
  Stream<QuerySnapshot> obtenerReportesPorCategoria(String categoria) {
    return reportesRef
        .where('categoria', isEqualTo: categoria)
        .orderBy('fechaReporte', descending: true)
        .snapshots();
  }

  /// Obtener reportes por prioridad
  Stream<QuerySnapshot> obtenerReportesPorPrioridad(String prioridad) {
    return reportesRef
        .where('prioridad', isEqualTo: prioridad)
        .orderBy('fechaReporte', descending: true)
        .snapshots();
  }
}