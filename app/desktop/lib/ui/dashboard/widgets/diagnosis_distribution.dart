import 'package:ahouefa/ui/dashboard/widgets/legend_entry.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DiagnosisDistribution extends StatelessWidget {
  const DiagnosisDistribution({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Repartition des diagnostiques',
                  style: textTheme.bodyLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    // Refresh logic here
                  },
                ),
              ],
            ),
          ),
          Expanded(
            flex: 9,
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: PieChart(
                    PieChartData(
                      borderData: FlBorderData(show: false),
                      sections: [
                        PieChartSectionData(
                          title: "${(10 / 15 * 100).toInt()}%",
                          color: Colors.greenAccent,
                          radius: 50,
                          value: 10,
                        ),
                        PieChartSectionData(
                          title: "${(5 / 15 * 100).toInt()}%",
                          color: Colors.redAccent,
                          value: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LegendEntry(label: "NORMAL", color: Colors.greenAccent),
                      LegendEntry(label: "PNEUMONIE", color: Colors.redAccent),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
