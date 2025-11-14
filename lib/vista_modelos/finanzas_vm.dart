import 'package:flutter/foundation.dart';

class FinanzasViewModel extends ChangeNotifier {
  final List<double> _mensual = [
    1200, 1600, 2200, 1800, 2100, 2000, 2500, 2700, 2400, 2800, 3000, 2900
  ];

  List<double> get mensual => List.unmodifiable(_mensual);

  double get totalAnual => _mensual.fold(0.0, (a, b) => a + b);
  double get promedioMensual => totalAnual / _mensual.length;

  void actualizarMes(int idx, double val) {
    if (idx < 0 || idx >= _mensual.length) return;
    _mensual[idx] = val;
    notifyListeners();
  }
}
