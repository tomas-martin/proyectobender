import 'package:cloud_firestore/cloud_firestore.dart';

class PropiedadesServicio {
  final CollectionReference propiedadesRef =
  FirebaseFirestore.instance.collection('propiedades');

  Stream<QuerySnapshot> obtenerPropiedades() {
    return propiedadesRef.orderBy('createdAt', descending: true).snapshots();
  }

  Future<void> agregarPropiedad(Map<String, dynamic> data) async {
    data['createdAt'] = FieldValue.serverTimestamp();
    await propiedadesRef.add(data);
  }

  Future<void> actualizarPropiedad(String id, Map<String, dynamic> data) async {
    await propiedadesRef.doc(id).update(data);
  }

  Future<void> borrarPropiedad(String id) async {
    await propiedadesRef.doc(id).delete();
  }
}
