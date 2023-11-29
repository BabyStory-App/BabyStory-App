import 'dart:convert';
import 'dart:io';
import 'package:babystory/models/baby.dart';
import 'package:babystory/models/cry_state.dart';
import 'package:babystory/models/parent.dart';
import 'package:babystory/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:babystory/utils/os.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BabyApi {
  late String baseroot;

  BabyApi() {
    var root = dotenv.env['API_BASE_ROOT'] ?? '';
    baseroot = "$root/baby";
  }

  Future<List<Baby>> getBabies() async {
    var uri = Uri.parse('$baseroot/all');
    try {
      var token = 'bearer_token';
      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      var json = jsonDecode(response.body);

      // if (response.statusCode == 200) {
      //   debugPrint("Upload successful!");
      // } else {
      //   debugPrint("Upload failed with status: ${response.statusCode}.");
      // }
      // return Parent.fromJson(json);
      return [];
    } catch (e) {
      debugPrintStack();
      return [];
    }
  }
}
