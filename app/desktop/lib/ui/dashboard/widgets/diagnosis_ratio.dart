import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DiagnosisRatio extends StatelessWidget {
  const DiagnosisRatio({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Column(
        children: [
          Text("Moyenne mobile des infections", style: textTheme.bodyLarge),
          PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(value: 45),
                PieChartSectionData(value: 23),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
