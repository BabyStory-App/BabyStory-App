import 'dart:convert';
import 'dart:io';
import 'package:babystory/models/cry_state.dart';
import 'package:babystory/models/parent.dart';
import 'package:flutter/material.dart';
import 'package:babystory/utils/os.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ParentApi {
  late String baseroot;

  ParentApi() {
    var root = dotenv.env['API_BASE_ROOT'] ?? '';
    baseroot = "$root/parent";
  }

  Future<Parent?> getUser({required String uid}) async {
    // send uid to server in header
    return null;

    //   try {
    //     var response = await http.get(uri);
    //     var json = jsonDecode(response.body);

    //     if (response.statusCode == 200) {
    //       debugPrint("Upload successful!");
    //     } else {
    //       debugPrint("Upload failed with status: ${response.statusCode}.");
    //     }
    //     print("json");
    //     print(json);
    //     // return Parent.fromJson(json);
    //     return null;
    //   } catch (e) {
    //     debugPrintStack();
    //     // throw "Error on ParentApi";
    //     return null;
    //   }
  }
}
