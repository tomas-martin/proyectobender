import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../modelos/aviso.dart';

class AvisosViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<Aviso> _lista = [];
  List<Aviso> get avisos => _lista;

  bool cargando = true;
  String? error;

  StreamSubscription<QuerySnapshot>? _subscription;

  AvisosViewModel() {
    escucharAvisos();
  }

  void escucharAvisos() {
    try {
      cargando = true;
      error = null;
      notifyListeners();

      _subscription = _db
          .collection('avisos')
          .orderBy('fecha', descending: true)
          .snapshots()
          .listen(
            (snapshot) {
          _lista = snapshot.docs.map((doc) => Aviso.fromMap(doc.id, doc.data())).toList();
          cargando = false;
          notifyListeners();
        },
        onError: (e) {
          error = "Error al cargar avisos: $e";
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

  Future<void> agregar(Aviso a) async {
    try {
      await _db.collection('avisos').add(a.toMap());
    } catch (e) {
      error = "Error al agregar aviso: $e";
      notifyListeners();
      rethrow;
    }
  }

  Future<void> actualizar(String id, Aviso a) async {
    try {
      await _db.collection('avisos').doc(id).update(a.toMap());
    } catch (e) {
      error = "Error al actualizar aviso: $e";
      notifyListeners();
      rethrow;
    }
  }

  Future<void> eliminar(String id) async {
    try {
      await _db.collection('avisos').doc(id).delete();
    } catch (e) {
      error = "Error al eliminar aviso: $e";
      notifyListeners();
      rethrow;
    }
  }

  Future<void> marcarLeido(String id) async {
    try {
      await _db.collection('avisos').doc(id).update({'leido': true});
    } catch (e) {
      error = "Error: $e";
      notifyListeners();
      rethrow;
    }
  }

  List<Aviso> get avisosNoLeidos => _lista.where((a) => !a.leido).toList();
  int get cantidadNoLeidos => avisosNoLeidos.length;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}