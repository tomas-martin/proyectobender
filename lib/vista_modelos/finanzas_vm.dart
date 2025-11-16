import 'package:flutter/foundation.dart';
import '../modelos/pago.dart';

class FinanzasViewModel extends ChangeNotifier {
  List<double> _mensual = List.filled(12, 0.0);
  List<Pago> _pagos = [];

  List<double> get mensual => List.unmodifiable(_mensual);

  double get totalAnual => _mensual.fold(0.0, (a, b) => a + b);
  double get promedioMensual => totalAnual / 12;

  /// ✅ NUEVO: Actualizar con pagos reales de Firebase
  void actualizarConPagos(List<Pago> pagos) {
    _pagos = pagos;
    _calcularIngresosMensuales();
    notifyListeners();
  }

  /// ✅ NUEVO: Calcular ingresos mensuales desde pagos
  void _calcularIngresosMensuales() {
    // Resetear todos los meses a 0
    _mensual = List.filled(12, 0.0);

    final ahora = DateTime.now();
    final anoActual = ahora.year;

    // Filtrar solo pagos del año actual que estén pagados
    final pagosPagados = _pagos.where((p) =>
    p.estaPagado &&
    p.fecha.year == anoActual
    );

    // Sumar los montos por mes
    for (final pago in pagosPagados) {
    final mesIndex = pago.fecha.month - 1; // 0-11
    if (mesIndex >= 0 && mesIndex < 12) {
    _mensual[mesIndex] += pago.monto;
    }
    }
  }

  /// ✅ NUEVO: Obtener ingresos de un mes específico
  double ingresoDelMes(int mes) {
    if (mes < 1 || mes > 12) return 0.0;
    return _mensual[mes - 1];
  }

  /// ✅ NUEVO: Obtener total de pagos pendientes
  double get totalPendiente {
    return _pagos
        .where((p) => p.estaPendiente)
        .fold(0.0, (sum, p) => sum + p.monto);
  }

  /// ✅ NUEVO: Obtener total de pagos morosos
  double get totalMoroso {
    return _pagos
        .where((p) => p.estaMoroso)
        .fold(0.0, (sum, p) => sum + p.monto);
  }

  /// ✅ NUEVO: Obtener cantidad de pagos por estado
  int get cantidadPagados => _pagos.where((p) => p.estaPagado).length;
  int get cantidadPendientes => _pagos.where((p) => p.estaPendiente).length;
  int get cantidadMorosos => _pagos.where((p) => p.estaMoroso).length;

  /// ✅ NUEVO: Obtener mes con más ingresos
  String get mejorMes {
    if (_mensual.every((m) => m == 0)) return 'Sin datos';

    final maxIngreso = _mensual.reduce((a, b) => a > b ? a : b);
    final mesIndex = _mensual.indexOf(maxIngreso);

    const meses = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];

    return meses[mesIndex];
  }

  /// ✅ NUEVO: Proyección para fin de año
  double get proyeccionAnual {
    final ahora = DateTime.now();
    final mesActual = ahora.month;

    if (mesActual == 0) return 0.0;

    final promedioHastaAhora = totalAnual / mesActual;
    return promedioHastaAhora * 12;
  }

  /// Método legacy - mantener por compatibilidad
  void actualizarMes(int idx, double val) {
    if (idx < 0 || idx >= _mensual.length) return;
    _mensual[idx] = val;
    notifyListeners();
  }
}