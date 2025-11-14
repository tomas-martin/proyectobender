import 'package:flutter/foundation.dart';
import '../modelos/pago.dart';

class PagosViewModel extends ChangeNotifier {
  final List<Pago> _pagos = [
    Pago(id: 'pay1', inquilino: 'Philip J. Fry', monto: 5000, estado: 'pagado', fecha: DateTime.now().subtract(const Duration(days: 8))),
    Pago(id: 'pay2', inquilino: 'Turanga Leela', monto: 4500, estado: 'pendiente', fecha: DateTime.now().subtract(const Duration(days: 2))),
    Pago(id: 'pay3', inquilino: 'Dr. Zoidberg', monto: 0, estado: 'moroso', fecha: DateTime.now().subtract(const Duration(days: 30))),
  ];

  List<Pago> get pagos => List.unmodifiable(_pagos);

  void marcarPagado(String id) {
    final idx = _pagos.indexWhere((p) => p.id == id);
    if (idx >= 0) {
      _pagos[idx] = Pago(
        id: _pagos[idx].id,
        inquilino: _pagos[idx].inquilino,
        monto: _pagos[idx].monto,
        estado: 'pagado',
        fecha: _pagos[idx].fecha,
      );
      notifyListeners();
    }
  }
}
