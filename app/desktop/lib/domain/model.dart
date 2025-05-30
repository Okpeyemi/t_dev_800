import 'dart:math';
import 'dart:typed_data';

import 'package:image/image.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class Model {
  final Interpreter _interpreter;
  Model._(Interpreter interpreter) : _interpreter = interpreter;
  static Model? _instance;

  static Future<Model> getInstance() async {
    _instance ??= Model._(
      await Interpreter.fromAsset("assets/models/predict.tflite"),
    );
    return _instance!;
  }

  Future<double> predict(Uint8List image) async {
    var img = decodeImage(image);
    var output = List.filled(1 * 3, 0).reshape([1, 3]);
    _interpreter.run([img], output);

    return Random().nextDouble();
  }
}
