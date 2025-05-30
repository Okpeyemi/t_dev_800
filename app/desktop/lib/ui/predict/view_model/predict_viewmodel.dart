import 'dart:io';
import 'dart:typed_data';

import 'package:ahouefa/domain/model.dart';
import 'package:ahouefa/utils/logging.dart';
import 'package:flutter/material.dart';

class PredictViewmodel extends ChangeNotifier {
  Uint8List? _image;
  String? _selectionDir;

  Uint8List? get image => _image;
  String? get selectionDir => _selectionDir;

  Future<double> predict(Uint8List image) async {
    var model = await Model.getInstance();
    return model.predict(image);
  }

  Future<void> setSelectedFile(File file) async {
    _selectionDir = file.absolute.parent.path;
    _image = await file.readAsBytes();
    logger.i("{NewImageSelected} selected file: ${file.path}");
    notifyListeners();
  }

  void removeSelectedFile() {
    _image = null;
    logger.i("{CurrentSelectionRemoved}");
    notifyListeners();
  }
}
