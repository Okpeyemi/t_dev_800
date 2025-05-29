import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class PredictViewmodel extends ChangeNotifier {
  Uint8List? _image;
  String? _selectionDir;

  Uint8List? get image => _image;
  String? get selectionDir => _selectionDir;

  Future<void> setSelectedFile(File? file) async {
    if (file != null) {
      _selectionDir = file.absolute.parent.path;
      _image = await file.readAsBytes();
    } else {
      _image = null;
    }
    notifyListeners();
  }
}
