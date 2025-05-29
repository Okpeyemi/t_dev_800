import 'dart:typed_data';
import "package:tflite_flutter/tflite_flutter.dart";

class Model {
  late Interpreter _interpreter;
  Model._(Interpreter interpreter) {
    _interpreter = interpreter;
  }
  static Future<Model> getInstance() async {
    _instance ??= Model._(await Interpreter.fromAsset("models/predict.tflite"));
    return _instance!;
  }

  static Model? _instance;
  Future<double> predict(Uint8List image) async {
    return 0.0; // Placeholder for actual prediction logic
  }
}
