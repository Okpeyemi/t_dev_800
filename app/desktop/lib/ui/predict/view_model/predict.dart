import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:ahouefa/domain/model.dart';
import 'package:ahouefa/domain/prediction.dart';
import 'package:ahouefa/ui/shared/view_model/file_selector.dart';
import 'package:ahouefa/utils/logging.dart';
import 'package:ahouefa/utils/storage.dart';
import 'package:flutter/material.dart';

class PredictViewModel extends ChangeNotifier with FileSelectorViewModel {
  Future<Prediction> predict(Uint8List image) async {
    var model = await Model.getInstance();
    final prediction = Prediction(
      imagePath: "",
      score: await model.predict(image),
    );
    final filename = _randomFilename();
    prediction.imagePath = "${Directories.predictions.path}/$filename";
    File(prediction.imagePath).writeAsBytes(image);
    logger.i("{PredictionMade} score: ${prediction.score}");
    return prediction;
  }

  String _randomFilename() {
    final random = Random();
    final characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    String filename = '';

    for (int i = 0; i < 12; i++) {
      filename += characters[random.nextInt(characters.length)];
    }
    return filename;
  }
}
