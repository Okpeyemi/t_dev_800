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
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(Icons.arrow_back, size: 44),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
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
                                child: TextIndicator(
                                  label: const Text(
                                    'Nb de prediction sur 7jrs (nb de malades)',
                                  ),
                                  value: Text(
                                    '123 (2)',
                                    style: textTheme.titleLarge,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextIndicator(
                                  color: Colors.greenAccent[100],
                                  label: Text(
                                    'Risque de pandémie',
                                    style: textTheme.bodyMedium!.copyWith(
                                      color: Colors.black,
                                    ),
                                  ),
                                  value: Text(
                                    'FAIBLE',
                                    style: textTheme.titleLarge!.copyWith(
                                      color: Colors.black,
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
                          child: ListView(
                            children: List.generate(
                              8,
                              (i) => ListTile(
                                title: Text('Patient ${i + 1}'),
                                subtitle: Text('Absence de pneumonie (6%)'),
                                trailing: Text("2025-06-12"),
                                onTap: () {
                                  // Navigate to prediction result screen
                                  // Navigator.push(context, Routes.predictionResultScreen(prediction: prediction));
                                },
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
