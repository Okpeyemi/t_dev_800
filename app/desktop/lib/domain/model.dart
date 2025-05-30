import 'dart:math';
import 'dart:typed_data';

class Model {
  Model._();
  static Model? _instance;

  static Future<Model> getInstance() async {
    _instance ??= Model._();
    return _instance!;
  }

  Future<double> predict(Uint8List image) async {
    return Random().nextDouble();
  }
}
