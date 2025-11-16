import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../vista_modelos/finanzas_vm.dart';

class GraficoIngresos extends StatelessWidget {
  const GraficoIngresos({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ OBTENER DATOS REALES DE FINANZAS
    final finanzasVM = Provider.of<FinanzasViewModel>(context);

    const meses = ['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'];
    final valores = finanzasVM.mensual; // ✅ DATOS REALES

    // Si todos son 0, mostrar mensaje
    final tieneAlgunDato = valores.any((v) => v > 0);

    if (!tieneAlgunDato) {
      return Container(
        height: 170,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.show_chart, size: 48, color: Colors.white24),
              SizedBox(height: 12),
              Text(
                'No hay pagos registrados aún',
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
              SizedBox(height: 4),
              Text(
                'Los datos aparecerán cuando registres pagos',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    // Calcular el valor máximo para el eje Y
    final maxVal = valores.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 170,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxVal > 0 ? maxVal * 1.2 : 1000, // 20% más alto que el máximo
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => Colors.black87,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '\$${rod.toY.toStringAsFixed(0)}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= meses.length) return const SizedBox.shrink();
                  return Text(
                    meses[i],
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxVal > 0 ? maxVal / 4 : 250,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.white.withOpacity(0.1),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(show: false),
          barGroups: valores.asMap().entries.map((e) {
            final idx = e.key;
            final val = e.value;

            // Resaltar el mes actual
            final mesActual = DateTime.now().month - 1;
            final esActual = idx == mesActual;

            return BarChartGroupData(
              x: idx,
              barRods: [
                BarChartRodData(
                  toY: val > 0 ? val : 0.1, // Mínimo visible si es 0
                  width: 12,
                  color: esActual
                      ? Colors.amber
                      : (val > 0
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.7)
                      : Colors.white.withOpacity(0.1)),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                )
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}