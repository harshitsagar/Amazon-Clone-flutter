import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:amazon_clone/features/admin/models/sales.dart';

class CategoryProductsChart extends StatelessWidget {
  final List<Sales> data;

  const CategoryProductsChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _getMaxY(),
        minY: 0,
        barTouchData: BarTouchData(enabled: false),

        // ---------- TITLES ----------
        titlesData: FlTitlesData(
          show: true,

          // Bottom Titles (Category Names)
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 38,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index < data.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      data[index].label,
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),

          // Left Titles (Y Axis numbers)
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: _leftInterval(),
              reservedSize: 42,
              getTitlesWidget: (value, _) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87),
                ),
              ),
            ),
          ),

          // Remove unused axes
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),

        // ---------- GRID LINES (ONLY X AXIS) ----------
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true, // ← no Y-axis lines
          verticalInterval: 1,
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey.shade300,
              strokeWidth: 1,
              dashArray: [4, 4], // dotted
            );
          },
        ),

        // ---------- REMOVE BORDERS ----------
        borderData: FlBorderData(show: true, border: Border.all(color: Colors.amber.shade900, width: 1)),

        // ---------- BARS ----------
        barGroups: data
            .asMap()
            .entries
            .map(
              (e) => BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: e.value.earnings.toDouble(),
                color: Colors.blue,
                width: 20,
                borderRadius: BorderRadius.zero,
              )
            ],
          ),
        ).toList(),
      ),
    );
  }

  double _getMaxY() {
    double maxVal = data
        .map((e) => e.earnings)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();
    return maxVal + 300;
  }

  double _leftInterval() => 700;
}


/*
import 'package:amazon_clone/features/admin/models/sales.dart';
import 'package:flutter/material.dart';

class CategoryProductsChart extends StatelessWidget {
  final List<charts.Series<Sales, String>> seriesList;

  const CategoryProductsChart({super.key, required this.seriesList});

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: true,
    );
  }
}


 */