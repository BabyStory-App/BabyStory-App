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
    print("inside getPrediction");
    print(filePath);
    print(jwt);
    if (OsUtils.isFileExist(filePath) == false) {
      print("file not exists");
      throw OSError('file $filePath not exist');
    }

    try {
      print("send predict request");
      print('$filePath, $jwt');
      var json = await httpUtils.postMultipart(
          url: '/cry/predict',
          headers: {'Authorization': 'Bearer ${jwt ?? ''}'},
          filePath: filePath);
      print("get predict response");
      print(json);
      if (json == null) {
        throw "Error on PredictApi";
      }
      return CryState.fromJson(json);
      // var uri = Uri.parse("$baseroot/cry/predict");

      // // post file and uid(user_id)
      // var request = http.MultipartRequest('POST', uri)
      //   ..files.add(await http.MultipartFile.fromPath('file', filePath))
      //   ..fields['uid'] = 'test';

      // var streamedResponse = await request.send();
      // var response = await http.Response.fromStream(streamedResponse);
      // var json = jsonDecode(response.body);

      // if (response.statusCode == 200) {
      //   debugPrint("Upload successful!");
      // } else {
      //   debugPrint("Upload failed with status: ${response.statusCode}.");
      // }
      // return CryState.fromJson(json);
    } catch (e) {
      debugPrintStack();
      throw "Error on PredictApi";
    }
  }
}
