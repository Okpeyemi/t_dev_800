import 'dart:io';
import 'dart:typed_data';

import 'package:ahouefa/utils/logging.dart';

mixin FileSelectorViewModel {
  Uint8List? _image;
  String? _selectionDir;

  Uint8List? get image => _image;
  String? get selectionDir => _selectionDir;

  void notifyListeners();

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
