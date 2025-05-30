import 'dart:io';

import 'package:ahouefa/domain/prediction.dart';
import 'package:ahouefa/ui/core/ui/clickable.dart';
import 'package:ahouefa/ui/prediction_result/widgets/receive_prediction_form.dart';
import 'package:flutter/material.dart';

class PredictionResultScreen extends StatelessWidget {
  final Prediction prediction;
  const PredictionResultScreen({super.key, required this.prediction});

  get isSick => prediction.score > 0.5;
  get message {
    if (prediction.score < 0.5) {
      return "Ce patient ne semble pas malade";
    } else if (prediction.score < 0.75) {
      return "Ce patient souffre probablement d'une pneumonie";
    } else {
      return "Ce patient souffre sûrement d'une pneumonie";
    }
  }

  @override
  Widget build(BuildContext context) {
    final textScheme = Theme.of(context).textTheme;
    final isSmallScreen = MediaQuery.sizeOf(context).width < 600;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                flex: 8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          "${(prediction.score * 100).toInt()} %",
                          style: textScheme.headlineSmall,
                        ),
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(
                            value: prediction.score,
                            color: isSick ? Colors.red : Colors.green,
                            strokeWidth: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(message, style: textScheme.headlineLarge),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Revoir l'image"),
                              content: Image.file(File(prediction.imagePath)),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Fermer"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text("Revoir l'image"),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Clickable(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Formulaire de reception"),
                          content: ReceivePredictionForm(
                            width: isSmallScreen ? null : 300,
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    "Vous desirez recevoir ce résultat par email ?",
                    style: textScheme.bodyLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
