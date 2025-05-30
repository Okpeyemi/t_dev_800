import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Directories {
  static late Directory appDir;
  static late Directory predictions;
  static init() async {
    var appDir_ = Directory(
      "${(await getApplicationDocumentsDirectory()).path}/ahouefa",
    );
    if (!await appDir_.exists()) {
      await appDir_.create(recursive: true);
      await Directory("${appDir_.path}/predictions").create(recursive: true);
    }
    appDir = appDir_;
    predictions = Directory("${appDir.path}/predictions");
  }
}
