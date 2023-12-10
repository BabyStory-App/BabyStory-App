import 'dart:convert';
import 'dart:io';
import 'package:babystory/models/cry_state.dart';
import 'package:babystory/utils/http.dart';
import 'package:flutter/material.dart';
import 'package:babystory/utils/os.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PredictApi {
  final HttpUtils httpUtils = HttpUtils();

  Future<CryState> getPrediction(
      {required String filePath, String? jwt}) async {
    if (OsUtils.isFileExist(filePath) == false) {
      throw OSError('file $filePath not exist');
    }

    try {
      var json = await httpUtils.postMultipart(
          url: '/cry/predict',
          headers: {'Authorization': 'Bearer ${jwt ?? ''}'},
          filePath: filePath);
      if (json == null) {
        throw "Error on PredictApi";
      }
      return CryState.fromJson(json);
    } catch (e) {
      print("Error on PredictApi");
      print(e);
      debugPrintStack();
      throw "Error on PredictApi";
    }
  }
}
