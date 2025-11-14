import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraficoIngresos extends StatelessWidget {
  const GraficoIngresos({super.key});

  @override
  Widget build(BuildContext context) {
    final meses = ['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'];
    final valores = [1200.0,1600,2200,1800,2100,2000,2500,2700,2400,2800,3000,2900];
    final maxVal = valores.reduce((a,b) => a > b ? a : b);

    return SizedBox(
      height: 170,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxVal * 1.2,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => Colors.black87,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '\$${rod.toY.toStringAsFixed(0)}',
                  const TextStyle(color: Colors.white),
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
                  return Text(meses[i], style: const TextStyle(color: Colors.grey, fontSize: 10));
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: valores.asMap().entries.map((e) {
            final idx = e.key;
            final val = e.value.toDouble();
            return BarChartGroupData(
              x: idx,
              barRods: [
                BarChartRodData(toY: val, width: 12, color: Theme.of(context).colorScheme.primary)
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
