import 'dart:convert';
import 'dart:io';
import 'package:babystory/models/cry_state.dart';
import 'package:flutter/material.dart';
import 'package:babystory/utils/os.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PredictApi {
  late String baseroot;

  PredictApi() {
    baseroot = dotenv.env['API_BASE_ROOT'] ?? '';
  }

  Future<CryState> getPrediction(
      {required String filePath, String api = '/'}) async {
    if (OsUtils.isFileExist(filePath) == false) {
      throw OSError('file $filePath not exist');
    }

    try {
      var uri = Uri.parse("$baseroot/baby/predict");
      print("uri: $baseroot/baby/predict");

      // post file and uid(user_id)
      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('file', filePath))
        ..fields['uid'] = 'test';

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      var json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        debugPrint("Upload successful!");
      } else {
        debugPrint("Upload failed with status: ${response.statusCode}.");
      }
      print("json");
      print(json);
      return CryState.fromJson(json);
    } catch (e) {
      debugPrintStack();
      throw "Error on PredictApi";
    }
  }
}
