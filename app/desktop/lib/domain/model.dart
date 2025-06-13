import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'package:ahouefa/config/settings.dart';
import 'package:ahouefa/utils/client.dart';

class Model {
  final http.Client _client;
  Model._() : _client = client;
  static Model? _instance;

  static Future<Model> getInstance() async {
    _instance ??= Model._();
    return _instance!;
  }

  Future<double> predict(Uint8List image) async {
    var request = http.MultipartRequest("POST", Uri.parse(predictionUrl));
    request.files.add(
      http.MultipartFile.fromBytes("scan", image, filename: "scan.png"),
    );
    var response = await _client.send(request);
    var payload = await response.stream.bytesToString();
    return double.parse(jsonDecode(payload));
  }

  String get predictionUrl => "${Settings.apiUrl}/api/predict";
}
