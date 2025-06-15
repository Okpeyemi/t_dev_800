import 'package:ahouefa/ui/dashboard/widgets/diagnosis_ma.dart';
import 'package:ahouefa/ui/dashboard/widgets/numeric_indicator.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final onSmallScreen = MediaQuery.sizeOf(context).width <= 600;

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body:
          onSmallScreen
              ? Column(
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder:
                          (context, constraints) => SizedBox(
                            width: constraints.maxWidth,
                            child: DiagnosisMA(
                              dataPoints: [
                                [0, 1],
                                [1, 2],
                                [2, 3],
                                [3, 2],
                                [4, 3],
                              ],
                            ),
                          ),
                    ),
                  ),
                ],
              )
              : LayoutBuilder(
                builder:
                    (context, constraints) => Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                flex: 7,
                                child: LayoutBuilder(
                                  builder:
                                      (context, constraints) => DiagnosisMA(
                                        dataPoints: [
                                          [0, 1],
                                          [1, 2],
                                          [2, 3],
                                          [3, 2],
                                          [4, 3],
                                        ],
                                      ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: LayoutBuilder(
                                  builder:
                                      (context, constraints) => Row(
                                        children: [
                                          SizedBox(
                                            width: constraints.maxWidth / 2,
                                            child: NumericIndicator(
                                              label: const Text(
                                                'Total Predictions',
                                              ),
                                              value: Text(
                                                '123',
                                                style: textTheme.bodyLarge,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: constraints.maxWidth / 2,
                                            child: NumericIndicator(
                                              label: const Text(
                                                'Total Predictions',
                                              ),
                                              value: Text(
                                                '123',
                                                style: textTheme.bodyLarge,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: LayoutBuilder(
                                  builder:
                                      (context, constraints) => SizedBox(
                                        width: constraints.maxWidth,
                                        child: NumericIndicator(
                                          label: const Text(
                                            'Total Predictions',
                                          ),
                                          value: Text(
                                            '123',
                                            style: textTheme.bodyLarge,
                                          ),
                                        ),
                                      ),
                                ),
                              ),
                              Expanded(
                                child: LayoutBuilder(
                                  builder:
                                      (context, constraints) => SizedBox(
                                        width: constraints.maxWidth,
                                        child: Card(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text('Total Predictions'),
                                              const SizedBox(height: 8),
                                              Text(
                                                '123', // Replace with actual data
                                                style:
                                                    Theme.of(
                                                      context,
                                                    ).textTheme.bodyLarge,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
              ),
    );
  }
}
