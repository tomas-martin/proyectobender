import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../modelos/reporte_problema.dart';
import '../servicios/reportes_servicio.dart';

class ReportesViewModel extends ChangeNotifier {
  final ReportesServicio _servicio = ReportesServicio();

  List<ReporteProblema> _lista = [];
  List<ReporteProblema> get reportes => _lista;

  bool cargando = true;
  String? error;

  StreamSubscription<QuerySnapshot>? _subscription;

  ReportesViewModel() {
    escucharReportes();
  }

  /// Escuchar cambios en tiempo real
  void escucharReportes() {
    try {
      cargando = true;
      error = null;
      notifyListeners();

      _subscription = _servicio.obtenerReportes().listen(
            (snapshot) {
          debugPrint('📦 Reportes recibidos: ${snapshot.docs.length}');

          _lista = snapshot.docs.map((doc) {
            return ReporteProblema.fromMap(doc.id, doc.data() as Map<String, dynamic>);
          }).toList();

          cargando = false;
          debugPrint('✅ Total reportes cargados: ${_lista.length}');
          notifyListeners();
        },
        onError: (e) {
          error = "Error al cargar reportes: $e";
          cargando = false;
          notifyListeners();
          debugPrint('❌ Error en stream de reportes: $e');
        },
      );
    } catch (e) {
      error = "Error de conexión: $e";
      cargando = false;
      notifyListeners();
      debugPrint('❌ Error iniciando stream: $e');
    }
  }

  /// Agregar nuevo reporte
  Future<void> agregar(ReporteProblema reporte) async {
    try {
      await _servicio.agregarReporte(reporte.toMap());
      debugPrint('✅ Reporte agregado');
    } catch (e) {
      error = "Error al agregar reporte: $e";
      notifyListeners();
      debugPrint('❌ Error: $e');
      rethrow;
    }
  }

  /// Actualizar reporte
  Future<void> actualizar(String id, ReporteProblema reporte) async {
    try {
      await _servicio.actualizarReporte(id, reporte.toMap());
      debugPrint('✅ Reporte actualizado');
    } catch (e) {
      error = "Error al actualizar reporte: $e";
      notifyListeners();
      rethrow;
    }
  }

  /// Eliminar reporte
  Future<void> eliminar(String id) async {
    try {
      await _servicio.borrarReporte(id);
      debugPrint('✅ Reporte eliminado');
    } catch (e) {
      error = "Error al eliminar reporte: $e";
      notifyListeners();
      rethrow;
    }
  }

  /// Marcar como resuelto
  Future<void> marcarResuelto(String id, String solucion) async {
    try {
      await _servicio.marcarComoResuelto(id, solucion);
      debugPrint('✅ Reporte marcado como resuelto');
    } catch (e) {
      error = "Error: $e";
      notifyListeners();
      rethrow;
    }
  }

  /// Cambiar estado
  Future<void> cambiarEstado(String id, String nuevoEstado) async {
    try {
      await _servicio.cambiarEstado(id, nuevoEstado);
      debugPrint('✅ Estado actualizado a: $nuevoEstado');
    } catch (e) {
      error = "Error: $e";
      notifyListeners();
      rethrow;
    }
  }

  /// Filtros
  List<ReporteProblema> get reportesPendientes =>
      _lista.where((r) => r.estaPendiente).toList();

  List<ReporteProblema> get reportesEnProceso =>
      _lista.where((r) => r.estaEnProceso).toList();

  List<ReporteProblema> get reportesResueltos =>
      _lista.where((r) => r.estaResuelto).toList();

  /// Contadores
  int get cantidadPendientes => reportesPendientes.length;
  int get cantidadEnProceso => reportesEnProceso.length;
  int get cantidadResueltos => reportesResueltos.length;

  /// Obtener reportes de una propiedad
  List<ReporteProblema> reportesPorPropiedad(String propiedadId) {
    return _lista.where((r) => r.propiedadId == propiedadId).toList();
  }

  /// Obtener reportes por categoría
  List<ReporteProblema> reportesPorCategoria(String categoria) {
    return _lista.where((r) => r.categoria == categoria).toList();
  }

  /// Obtener reportes por prioridad
  List<ReporteProblema> reportesPorPrioridad(String prioridad) {
    return _lista.where((r) => r.prioridad == prioridad).toList();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    debugPrint('🔌 ReportesViewModel disposed');
    super.dispose();
  }
}