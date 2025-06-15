import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

class DiagnosisMA extends StatelessWidget {
  final List<List<double>> dataPoints;
  const DiagnosisMA({super.key, required this.dataPoints});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                "Moyenne mobile des infections",
                style: textTheme.bodyLarge,
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: LineChart(
              LineChartData(
                minY: 0,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, interval: 1),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, interval: 1),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                // gridData: FlGridData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots:
                        dataPoints
                            .map((point) => FlSpot(point[0], point[1]))
                            .toList(),
                    isCurved: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
