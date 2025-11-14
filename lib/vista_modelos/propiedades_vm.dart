import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../modelos/propiedad.dart';

class PropiedadesViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<Propiedad> _lista = [];
  List<Propiedad> get propiedades => _lista;

  bool cargando = true;

  PropiedadesViewModel() {
    cargarPropiedades();
  }

  Future<void> cargarPropiedades() async {
    try {
      cargando = true;
      notifyListeners();

      final snapshot = await _db.collection('propiedades').get();

      _lista = snapshot.docs.map((doc) {
        return Propiedad.fromMap(doc.id, doc.data());
      }).toList();
    } catch (e) {
      print("Error cargando propiedades: $e");
    }

    cargando = false;
    notifyListeners();
  }

  Future<void> agregar(Propiedad p) async {
    await _db.collection('propiedades').add(p.toMap());
    cargarPropiedades();
  }

  Future<void> eliminar(String id) async {
    await _db.collection('propiedades').doc(id).delete();
    cargarPropiedades();
  }
}
