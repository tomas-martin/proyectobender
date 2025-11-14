class Pago {
  final String id;
  final String inquilino;
  final double monto;
  final String estado; // 'pagado', 'pendiente', 'moroso'
  final DateTime fecha;

  Pago({required this.id, required this.inquilino, required this.monto, required this.estado, required this.fecha});
}

