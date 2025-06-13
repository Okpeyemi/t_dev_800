import 'dart:typed_data';

import 'package:ahouefa/config/settings.dart';
import 'package:ahouefa/utils/client.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:ahouefa/ui/shared/view_model/file_selector.dart';

class AnnotateViewModel extends ChangeNotifier with FileSelectorViewModel {
  String _diagnosis;
  final http.Client _client;
  AnnotateViewModel() : _diagnosis = "NORMAL", _client = client;

  String get diagnosis => _diagnosis;

  void setDiagnosis(String value) {
    _diagnosis = value;
    notifyListeners();
  }

  Future<void> submitAnnotation(Uint8List image, String diagnosis) async {
    var request = http.MultipartRequest("POST", Uri.parse(annotationUrl));
    request.files.add(
      http.MultipartFile.fromBytes("scan", image, filename: "scan.png"),
    );
    request.fields["diagnosis"] = diagnosis;
    var response = await _client.send(request);
    if (response.statusCode != 200) {
      throw Exception(response.stream.bytesToString());
    }
  }

  String get annotationUrl => "${Settings.apiUrl}/api/annotate";
}
