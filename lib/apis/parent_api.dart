import 'dart:convert';
import 'dart:io';
import 'package:babystory/models/cry_state.dart';
import 'package:babystory/models/parent.dart';
import 'package:babystory/services/auth.dart';
import 'package:babystory/utils/http.dart';
import 'package:flutter/material.dart';
import 'package:babystory/utils/os.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ParentApi {
  late String baseroot;
  final HttpUtils httpUtils = HttpUtils();

  ParentApi() {
    var root = dotenv.env['API_BASE_ROOT'] ?? '';
    baseroot = "$root/parent/";
  }

  Future<String?> createParent({required Parent parent}) async {
    var uri = Uri.parse(baseroot);
    try {
      // var sendJson = jsonEncode({
      //   'uid': parent.uid,
      //   'email': parent.email,
      //   'nickname': parent.nickname,
      // });
      // var response = await http.post(uri,
      //     headers: {
      //       HttpHeaders.contentTypeHeader: 'application/json',
      //       HttpHeaders.acceptCharsetHeader: 'utf-8',
      //     },
      //     body: sendJson);
      // var json = jsonDecode(utf8.decode(response.bodyBytes));
      var json = await httpUtils.post(url: '/parent/', body: {
        'uid': parent.uid,
        'email': parent.email,
        'nickname': parent.nickname,
      });
      if (json == null || json['x-jwt'] == null) {
        debugPrint('createParent failed');
        return null;
      }
      return json['x-jwt']['access_token'];
    } catch (e) {
      debugPrintStack();
      debugPrint(e.toString());
      return null;
    }
  }

  Future<String?> getJwtToken({required String uid}) async {
    try {
      var json = await httpUtils.get(url: '/parent', headers: {'uid': uid});
      if (json == null ||
          json['x-jwt'] == null ||
          json['x-jwt']['access_token'] == null) {
        print('Jwt token not found');
        return null;
      }
      return json['x-jwt']['access_token'];
    } catch (e) {
      debugPrintStack();
      return null;
    }
  }
}
