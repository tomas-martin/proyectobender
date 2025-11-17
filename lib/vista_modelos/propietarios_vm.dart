import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../modelos/propietario.dart';

class PropietariosViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<Propietario> _lista = [];
  List<Propietario> get propietarios => _lista;

  bool cargando = true;
  String? error;

  StreamSubscription<QuerySnapshot>? _subscription;

  PropietariosViewModel() {
    escucharPropietarios();
  }

  void escucharPropietarios() {
    try {
      cargando = true;
      error = null;
      notifyListeners();

      _subscription = _db
          .collection('propietarios')
          .orderBy('fechaRegistro', descending: true)
          .snapshots()
          .listen(
            (snapshot) {
          debugPrint('📦 Propietarios recibidos: ${snapshot.docs.length}');

          _lista = snapshot.docs.map((doc) {
            return Propietario.fromMap(doc.id, doc.data());
          }).toList();

          cargando = false;
          debugPrint('✅ Total propietarios: ${_lista.length}');
          notifyListeners();
        },
        onError: (e) {
          error = "Error al cargar propietarios: $e";
          cargando = false;
          notifyListeners();
          debugPrint('❌ Error: $e');
        },
      );
    } catch (e) {
      error = "Error de conexión: $e";
      cargando = false;
      notifyListeners();
    }
  }

  Future<void> agregar(Propietario p) async {
    try {
      await _db.collection('propietarios').add(p.toMap());
      debugPrint('✅ Propietario agregado: ${p.nombre}');
    } catch (e) {
      error = "Error al agregar propietario: $e";
      notifyListeners();
      debugPrint('❌ Error: $e');
      rethrow;
    }
  }

  Future<void> actualizar(String id, Propietario p) async {
    try {
      await _db.collection('propietarios').doc(id).update(p.toMap());
      debugPrint('✅ Propietario actualizado: ${p.nombre}');
    } catch (e) {
      error = "Error al actualizar propietario: $e";
      notifyListeners();
      rethrow;
    }
  }

  Future<void> eliminar(String id) async {
    try {
      await _db.collection('propietarios').doc(id).delete();
      debugPrint('✅ Propietario eliminado');
    } catch (e) {
      error = "Error al eliminar propietario: $e";
      notifyListeners();
      rethrow;
    }
  }

  // Buscar propietario por ID
  Propietario? obtenerPorId(String id) {
    try {
      return _lista.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}