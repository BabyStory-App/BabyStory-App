import 'package:babystory/models/parent.dart';
import 'package:babystory/utils/http.dart';
import 'package:flutter/material.dart';

class ParentApi {
  final HttpUtils httpUtils = HttpUtils();

  Future<String?> createParent({required Parent parent}) async {
    try {
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
