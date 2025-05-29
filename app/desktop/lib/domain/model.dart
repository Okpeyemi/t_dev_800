import 'dart:typed_data';
import 'package:image/image.dart';
import "package:tflite_flutter/tflite_flutter.dart";

class Model {
  late Interpreter _interpreter;
  Model._(Interpreter interpreter) {
    _interpreter = interpreter;
  }
  static Future<Model> getInstance() async {
    _instance ??= Model._(
      await Interpreter.fromAsset("assets/models/predict.tflite"),
    );
    return _instance!;
  }

  static Model? _instance;
  Future<double> predict(Uint8List image) async {
    Image img = decodeImage(image)!;
    var output = List.filled(1 * 4, 0).reshape([1, 4]);
    _interpreter.run([img], output);
    return output[0][0][0];
  }
}
