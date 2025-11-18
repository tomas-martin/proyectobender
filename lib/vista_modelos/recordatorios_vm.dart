import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../modelos/recordatorio_pago.dart';
import '../servicios/recordatorios_servicio.dart';

class RecordatoriosViewModel extends ChangeNotifier {
  final RecordatoriosServicio _servicio = RecordatoriosServicio();

  List<RecordatorioPago> _lista = [];
  List<RecordatorioPago> get recordatorios => _lista;

  bool cargando = true;
  String? error;

  StreamSubscription<QuerySnapshot>? _subscription;

  RecordatoriosViewModel() {
    escucharRecordatorios();
  }

  /// Escuchar cambios en tiempo real
  void escucharRecordatorios() {
    try {
      cargando = true;
      error = null;
      notifyListeners();

      _subscription = _servicio.obtenerRecordatorios().listen(
            (snapshot) {
          debugPrint('📦 Recordatorios recibidos: ${snapshot.docs.length}');

          _lista = snapshot.docs.map((doc) {
            return RecordatorioPago.fromMap(doc.id, doc.data() as Map<String, dynamic>);
          }).toList();

          cargando = false;
          debugPrint('✅ Total recordatorios cargados: ${_lista.length}');
          notifyListeners();
        },
        onError: (e) {
          error = "Error al cargar recordatorios: $e";
          cargando = false;
          notifyListeners();
          debugPrint('❌ Error en stream de recordatorios: $e');
        },
      );
    } catch (e) {
      error = "Error de conexión: $e";
      cargando = false;
      notifyListeners();
      debugPrint('❌ Error iniciando stream: $e');
    }
  }

  /// Agregar nuevo recordatorio
  Future<void> agregar(RecordatorioPago recordatorio) async {
    try {
      await _servicio.agregarRecordatorio(recordatorio.toMap());
      debugPrint('✅ Recordatorio agregado');
    } catch (e) {
      error = "Error al agregar recordatorio: $e";
      notifyListeners();
      debugPrint('❌ Error: $e');
      rethrow;
    }
  }

  /// Actualizar recordatorio
  Future<void> actualizar(String id, RecordatorioPago recordatorio) async {
    try {
      await _servicio.actualizarRecordatorio(id, recordatorio.toMap());
      debugPrint('✅ Recordatorio actualizado');
    } catch (e) {
      error = "Error al actualizar recordatorio: $e";
      notifyListeners();
      rethrow;
    }
  }

  /// Eliminar recordatorio
  Future<void> eliminar(String id) async {
    try {
      await _servicio.borrarRecordatorio(id);
      debugPrint('✅ Recordatorio eliminado');
    } catch (e) {
      error = "Error al eliminar recordatorio: $e";
      notifyListeners();
      rethrow;
    }
  }

  /// Marcar como enviado
  Future<void> marcarEnviado(String id) async {
    try {
      await _servicio.marcarComoEnviado(id);
      debugPrint('✅ Recordatorio marcado como enviado');
    } catch (e) {
      error = "Error: $e";
      notifyListeners();
      rethrow;
    }
  }

  /// Obtener recordatorios vencidos
  List<RecordatorioPago> get recordatoriosVencidos =>
      _lista.where((r) => r.estaVencido).toList();

  /// Obtener recordatorios próximos
  List<RecordatorioPago> get recordatoriosProximos =>
      _lista.where((r) => r.estaProximo && !r.estaVencido).toList();

  /// Contadores
  int get cantidadVencidos => recordatoriosVencidos.length;
  int get cantidadProximos => recordatoriosProximos.length;

  /// Obtener recordatorios de una propiedad
  List<RecordatorioPago> recordatoriosPorPropiedad(String propiedadId) {
    return _lista.where((r) => r.propiedadId == propiedadId).toList();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    debugPrint('🔌 RecordatoriosViewModel disposed');
    super.dispose();
  }
}