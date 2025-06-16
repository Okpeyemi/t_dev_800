import 'package:ahouefa/ui/dashboard/widgets/dashboard_screen.dart';
import 'package:flutter/material.dart';

import 'package:ahouefa/domain/prediction.dart';
import 'package:ahouefa/ui/prediction_result/widgets/prediction_result_screen.dart';

class Routes {
  static MaterialPageRoute dashboard() {
    return MaterialPageRoute(builder: (context) => const DashboardScreen());
  }

  static MaterialPageRoute predictionResultScreen({
    required Prediction prediction,
  }) {
    return MaterialPageRoute(
      builder: (context) => PredictionResultScreen(prediction: prediction),
    );
  }
}
