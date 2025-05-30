import 'package:ahouefa/domain/prediction.dart';
import 'package:ahouefa/ui/prediction_result/widgets/prediction_result_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static MaterialPageRoute predictionResultScreen({
    required Prediction prediction,
  }) {
    return MaterialPageRoute(
      builder: (context) => PredictionResultScreen(prediction: prediction),
    );
  }
}
