import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../modelos/propiedad.dart';

class PropiedadesViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<Propiedad> _lista = [];
  List<Propiedad> get propiedades => _lista;

  bool cargando = true;
  String? error;

  StreamSubscription<QuerySnapshot>? _subscription;

  PropiedadesViewModel() {
    escucharPropiedades();
  }

  /// Escucha cambios en tiempo real de Firebase
  void escucharPropiedades() {
    try {
      cargando = true;
      error = null;
      notifyListeners();

      _subscription = _db
          .collection('propiedades')
          .snapshots()
          .listen(
            (snapshot) {
          _lista = snapshot.docs.map((doc) {
            return Propiedad.fromMap(doc.id, doc.data());
          }).toList();

          cargando = false;
          notifyListeners();
        },
        onError: (e) {
          error = "Error al cargar propiedades";
          cargando = false;
          notifyListeners();
        },
      );
    } catch (e) {
      error = "Error de conexión";
      cargando = false;
      notifyListeners();
    }
  }

  Future<void> agregar(Propiedad p) async {
    try {
      final data = p.toMap();
      data['createdAt'] = FieldValue.serverTimestamp();
      await _db.collection('propiedades').add(data);
    } catch (e) {
      error = "Error al agregar propiedad";
      notifyListeners();
    }
  }

  Future<void> actualizar(String id, Propiedad p) async {
    try {
      await _db.collection('propiedades').doc(id).update(p.toMap());
    } catch (e) {
      error = "Error al actualizar propiedad";
      notifyListeners();
    }
  }

  Future<void> eliminar(String id) async {
    try {
      await _db.collection('propiedades').doc(id).delete();
    } catch (e) {
      error = "Error al eliminar propiedad";
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}