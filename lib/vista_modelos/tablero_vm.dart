class TableroViewModel {
  // Lista de ingresos de los últimos 12 meses
  final List<int> ingresos = [
    1200, 1800, 1500, 2100, 2300, 1900, 2500, 2700, 2600, 3000, 2900, 2800
  ];

  int get totalAnual => ingresos.reduce((a, b) => a + b);

  int get promedioMensual => (totalAnual ~/ ingresos.length);
}
