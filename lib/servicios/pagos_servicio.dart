import 'package:cloud_firestore/cloud_firestore.dart';

class PagosServicio {
  final CollectionReference pagosRef =
  FirebaseFirestore.instance.collection('pagos');

  // Registrar un pago
  Future<void> agregarPago(Map<String, dynamic> data) async {
    await pagosRef.add(data);
  }

  // Traer pagos en tiempo real
  Stream<QuerySnapshot> obtenerPagos() {
    return pagosRef.snapshots();
  }

  // Marcar pago como realizado
  Future<void> actualizarPago(String id, Map<String, dynamic> data) async {
    await pagosRef.doc(id).update(data);
  }

  // Eliminar un pago
  Future<void> borrarPago(String id) async {
    await pagosRef.doc(id).delete();
  }
}
