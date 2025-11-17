import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../modelos/pago.dart';

class PagosViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<Pago> _lista = [];
  List<Pago> get pagos => _lista;

  bool cargando = true;
  String? error;

  StreamSubscription<QuerySnapshot>? _subscription;

  // ✅ Callback para notificar cambios a FinanzasViewModel
  void Function(List<Pago>)? onPagosActualizados;

  PagosViewModel() {
    escucharPagos();
  }

  /// Escucha cambios en tiempo real de Firebase
  void escucharPagos() {
    try {
      cargando = true;
      error = null;
      notifyListeners();

      _subscription = _db
          .collection('pagos')
          .orderBy('fecha', descending: true)
          .snapshots()
          .listen(
            (snapshot) {
          debugPrint('📦 Pagos recibidos: ${snapshot.docs.length}');

          _lista = snapshot.docs.map((doc) {
            return Pago.fromMap(doc.id, doc.data());
          }).toList();

          cargando = false;
          debugPrint('✅ Total pagos cargados: ${_lista.length}');

          // ✅ Notificar a FinanzasViewModel
          onPagosActualizados?.call(_lista);

          notifyListeners();
        },
        onError: (e) {
          error = "Error al cargar pagos: $e";
          cargando = false;
          notifyListeners();
          debugPrint('❌ Error en stream de pagos: $e');
        },
      );
    } catch (e) {
      error = "Error de conexión: $e";
      cargando = false;
      notifyListeners();
      debugPrint('❌ Error iniciando stream: $e');
    }
  }

  /// AGREGAR un nuevo pago
  Future<void> agregar(Pago pago) async {
    try {
      final data = pago.toMap();
      await _db.collection('pagos').add(data);
      debugPrint('✅ Pago agregado: ${pago.propietarioNombre ?? "sin propietario"}');
    } catch (e) {
      error = "Error al agregar pago: $e";
      notifyListeners();
      debugPrint('❌ Error agregando pago: $e');
      rethrow;
    }
  }

  /// MARCAR PAGO COMO PAGADO
  Future<void> marcarPagado(String id) async {
    try {
      await _db.collection('pagos').doc(id).update({
        'estado': 'pagado',
        'fecha': FieldValue.serverTimestamp(),
      });
      debugPrint('✅ Pago marcado como pagado: $id');
    } catch (e) {
      error = "Error al actualizar pago: $e";
      notifyListeners();
      debugPrint('❌ Error actualizando pago: $e');
      rethrow;
    }
  }

  /// ACTUALIZAR pago
  Future<void> actualizar(String id, Pago pago) async {
    try {
      await _db.collection('pagos').doc(id).update(pago.toMap());
      debugPrint('✅ Pago actualizado: $id');
    } catch (e) {
      error = "Error al actualizar pago: $e";
      notifyListeners();
      debugPrint('❌ Error actualizando pago: $e');
      rethrow;
    }
  }

  /// ELIMINAR pago
  Future<void> eliminar(String id) async {
    try {
      await _db.collection('pagos').doc(id).delete();
      debugPrint('✅ Pago eliminado: $id');
    } catch (e) {
      error = "Error al eliminar pago: $e";
      notifyListeners();
      debugPrint('❌ Error eliminando pago: $e');
      rethrow;
    }
  }

  /// Obtener pagos de una propiedad específica
  List<Pago> pagosPorPropiedad(String propiedadId) {
    return _lista.where((p) => p.propiedadId == propiedadId).toList();
  }

  /// Obtener último pago de una propiedad
  Pago? obtenerUltimoPago(String propiedadId) {
    final pagosProp = pagosPorPropiedad(propiedadId);
    if (pagosProp.isEmpty) return null;

    pagosProp.sort((a, b) => b.fecha.compareTo(a.fecha));
    return pagosProp.first;
  }

  /// Cargar pagos de una propiedad específica (filtrado local)
  void cargarPagosDePropiedad(String propiedadId) {
    notifyListeners();
  }

  /// Obtener pagos pendientes
  List<Pago> get pagosPendientes {
    return _lista.where((p) => p.estado == 'pendiente').toList();
  }

  /// Obtener pagos morosos
  List<Pago> get pagosMorosos {
    return _lista.where((p) => p.estado == 'moroso').toList();
  }

  /// Total de ingresos del mes actual
  double get ingresosDelMes {
    final ahora = DateTime.now();
    return _lista
        .where((p) =>
    p.estaPagado &&
        p.fecha.month == ahora.month &&
        p.fecha.year == ahora.year)
        .fold(0.0, (sum, p) => sum + p.monto);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    debugPrint('🔌 PagosViewModel disposed');
    super.dispose();
  }
}