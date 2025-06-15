import 'package:ahouefa/ui/dashboard/widgets/diagnosis_distribution.dart';
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
                ],
              )
              : Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          flex: 7,
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
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Expanded(
                                child: NumericIndicator(
                                  label: const Text('Total Predictions'),
                                  value: Text(
                                    '123',
                                    style: textTheme.bodyLarge,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: NumericIndicator(
                                  label: const Text('Total Predictions'),
                                  value: Text(
                                    '123',
                                    style: textTheme.bodyLarge,
                                  ),
                                ),
                              ),
                            ],
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
                                  child: DiagnosisDistribution(),
                                ),
                          ),
                        ),
                        Expanded(
                          child: LayoutBuilder(
                            builder:
                                (context, constraints) => SizedBox(
                                  width: constraints.maxWidth,
                                  child: NumericIndicator(
                                    label: const Text('Total Predictions'),
                                    value: Text(
                                      '123',
                                      style: textTheme.bodyLarge,
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
    );
  }
}
