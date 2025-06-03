import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:ahouefa/domain/model.dart';
import 'package:ahouefa/domain/prediction.dart';
import 'package:ahouefa/utils/logging.dart';
import 'package:ahouefa/utils/storage.dart';
import 'package:flutter/material.dart';

class PredictViewmodel extends ChangeNotifier {
  Uint8List? _image;
  String? _selectionDir;

  Uint8List? get image => _image;
  String? get selectionDir => _selectionDir;

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

  Future<void> setSelectedFile(File file) async {
    _selectionDir = file.absolute.parent.path;
    _image = await file.readAsBytes();
    logger.i("{NewImageSelected} selected file: ${file.path}");
    notifyListeners();
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

  void removeSelectedFile() {
    _image = null;
    logger.i("{CurrentSelectionRemoved}");
    notifyListeners();
  }
}
