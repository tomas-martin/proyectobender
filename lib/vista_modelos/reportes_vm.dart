import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../modelos/reporte_problema.dart';

class ReportesViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<ReporteProblema> _lista = [];
  List<ReporteProblema> get reportes => _lista;

  bool cargando = true;
  String? error;

  StreamSubscription<QuerySnapshot>? _subscription;

  ReportesViewModel() {
    escucharReportes();
  }

  void escucharReportes() {
    try {
      cargando = true;
      error = null;
      notifyListeners();

      _subscription = _db
          .collection('reportes')
          .orderBy('fechaReporte', descending: true)
          .snapshots()
          .listen(
            (snapshot) {
          _lista = snapshot.docs
              .map((doc) => ReporteProblema.fromMap(doc.id, doc.data()))
              .toList();
          cargando = false;
          notifyListeners();
        },
        onError: (e) {
          error = "Error al cargar reportes: $e";
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

  Future<void> agregar(ReporteProblema reporte) async {
    try {
      await _db.collection('reportes').add(reporte.toMap());
    } catch (e) {
      error = "Error al agregar reporte: $e";
      notifyListeners();
      rethrow;
    }
  }

  Future<void> actualizar(String id, ReporteProblema reporte) async {
    try {
      await _db.collection('reportes').doc(id).update(reporte.toMap());
    } catch (e) {
      error = "Error al actualizar reporte: $e";
      notifyListeners();
      rethrow;
    }
  }

  Future<void> eliminar(String id) async {
    try {
      await _db.collection('reportes').doc(id).delete();
    } catch (e) {
      error = "Error al eliminar reporte: $e";
      notifyListeners();
      rethrow;
    }
  }

  Future<void> marcarResuelto(String id, String solucion) async {
    try {
      await _db.collection('reportes').doc(id).update({
        'estado': 'resuelto',
        'fechaResolucion': FieldValue.serverTimestamp(),
        'solucion': solucion,
      });
    } catch (e) {
      error = "Error: $e";
      notifyListeners();
      rethrow;
    }
  }

  List<ReporteProblema> get reportesPendientes =>
      _lista.where((r) => r.estaPendiente).toList();

  List<ReporteProblema> get reportesEnProceso =>
      _lista.where((r) => r.estaEnProceso).toList();

  int get cantidadPendientes => reportesPendientes.length;
  int get cantidadEnProceso => reportesEnProceso.length;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}