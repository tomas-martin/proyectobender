import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../modelos/recordatorio_pago.dart';

class RecordatoriosViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<RecordatorioPago> _lista = [];
  List<RecordatorioPago> get recordatorios => _lista;

  bool cargando = true;
  String? error;

  StreamSubscription<QuerySnapshot>? _subscription;

  RecordatoriosViewModel() {
    escucharRecordatorios();
  }

  void escucharRecordatorios() {
    try {
      cargando = true;
      error = null;
      notifyListeners();

      _subscription = _db
          .collection('recordatorios')
          .orderBy('fechaVencimiento')
          .snapshots()
          .listen(
            (snapshot) {
          _lista = snapshot.docs
              .map((doc) => RecordatorioPago.fromMap(doc.id, doc.data()))
              .toList();
          cargando = false;
          notifyListeners();
        },
        onError: (e) {
          error = "Error al cargar recordatorios: $e";
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

  Future<void> agregar(RecordatorioPago recordatorio) async {
    try {
      await _db.collection('recordatorios').add(recordatorio.toMap());
    } catch (e) {
      error = "Error al agregar recordatorio: $e";
      notifyListeners();
      rethrow;
    }
  }

  Future<void> actualizar(String id, RecordatorioPago recordatorio) async {
    try {
      await _db.collection('recordatorios').doc(id).update(recordatorio.toMap());
    } catch (e) {
      error = "Error al actualizar recordatorio: $e";
      notifyListeners();
      rethrow;
    }
  }

  Future<void> eliminar(String id) async {
    try {
      await _db.collection('recordatorios').doc(id).delete();
    } catch (e) {
      error = "Error al eliminar recordatorio: $e";
      notifyListeners();
      rethrow;
    }
  }

  Future<void> marcarEnviado(String id) async {
    try {
      await _db.collection('recordatorios').doc(id).update({
        'estado': 'enviado',
        'notificado': true,
        'fechaNotificacion': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      error = "Error: $e";
      notifyListeners();
      rethrow;
    }
  }

  List<RecordatorioPago> get recordatoriosVencidos =>
      _lista.where((r) => r.estaVencido).toList();

  List<RecordatorioPago> get recordatoriosProximos =>
      _lista.where((r) => r.estaProximo && !r.estaVencido).toList();

  int get cantidadVencidos => recordatoriosVencidos.length;
  int get cantidadProximos => recordatoriosProximos.length;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}