import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:probando_app_bender_v0/modelos/error_sistema.dart';
import '../modelos/aviso.dart';

class ErroresViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<ErrorSistema> _lista = [];
  List<ErrorSistema> get errores => _lista;

  bool cargando = true;
  String? error;

  StreamSubscription<QuerySnapshot>? _subscription;

  ErroresViewModel() {
    escucharErrores();
  }

  void escucharErrores() {
    try {
      cargando = true;
      error = null;
      notifyListeners();

      _subscription = _db
          .collection('errores')
          .orderBy('fecha', descending: true)
          .snapshots()
          .listen(
            (snapshot) {
          _lista = snapshot.docs.map((doc) => ErrorSistema.fromMap(doc.id, doc.data())).toList();
          cargando = false;
          notifyListeners();
        },
        onError: (e) {
          error = "Error al cargar errores: $e";
          cargando = false;
          notifyListeners();
        },
      );
    } catch (e) {
      error = "Error de conexión: $e";
      cargando = false;
      notifyListeners();
    }
  }

  Future<void> agregar(ErrorSistema err) async {
    try {
      await _db.collection('errores').add(err.toMap());
    } catch (e) {
      error = "Error al agregar error: $e";
      notifyListeners();
      rethrow;
    }
  }

  Future<void> actualizar(String id, ErrorSistema err) async {
    try {
      await _db.collection('errores').doc(id).update(err.toMap());
    } catch (e) {
      error = "Error al actualizar error: $e";
      notifyListeners();
      rethrow;
    }
  }

  Future<void> eliminar(String id) async {
    try {
      await _db.collection('errores').doc(id).delete();
    } catch (e) {
      error = "Error al eliminar error: $e";
      notifyListeners();
      rethrow;
    }
  }

  Future<void> marcarResuelto(String id, String solucion) async {
    try {
      await _db.collection('errores').doc(id).update({
        'resuelto': true,
        'solucion': solucion,
      });
    } catch (e) {
      error = "Error: $e";
      notifyListeners();
      rethrow;
    }
  }

  List<ErrorSistema> get erroresNoResueltos => _lista.where((e) => !e.resuelto).toList();
  int get cantidadNoResueltos => erroresNoResueltos.length;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}