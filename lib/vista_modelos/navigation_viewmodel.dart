import 'package:flutter/foundation.dart';

/// ViewModel para controlar el índice de navegación principal.
class NavigationViewModel extends ChangeNotifier {
  int _indiceActual = 0;
  int get indiceActual => _indiceActual;

  /// Cambia el índice solo si es distinto
  void cambiarIndice(int nuevo) {
    if (nuevo == _indiceActual) return;
    _indiceActual = nuevo;
    notifyListeners();
  }
}
