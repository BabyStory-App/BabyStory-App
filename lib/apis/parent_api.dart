import 'package:babystory/models/parent.dart';
import 'package:babystory/utils/http.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParentApi {
  final HttpUtils httpUtils = HttpUtils();

  Future<String?> createParent(
      {required Parent parent, required String password}) async {
    try {
      var json = await httpUtils.post(url: '/parent/', body: {
        'parent_id': parent.uid,
        'email': parent.email,
        'nickname': parent.nickname,
        'password': password,
        'signInMethod': password == 'google-auth' ? 'google' : 'email',
        'emailVerified': parent.emailVerified,
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

  Future<String?> login(
      {required Parent parent, required String password}) async {
    try {
      var json = await httpUtils.post(url: '/parent/login', body: {
        'email': parent.email,
        'password': password,
      });
      if (json == null || json['x-jwt'] == null) {
        debugPrint('Login failed');
        return null;
      }
      return json['x-jwt']['access_token'];
    } catch (e) {
      return null;
    }
  }

  Future<Parent?> getParent({required String uid}) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      var jwt = prefs.getString('x-jwt');
      if (jwt == null) {
        return null;
      }
      var json = await httpUtils
          .get(url: '/parent', headers: {'Authorization': 'Bearer $jwt'});
      if (json == null ||
          json['x-jwt'] == null ||
          json['x-jwt']['access_token'] == null) {
        return null;
      }
      var parent = Parent(
        uid: json['parent']['parent_id'],
        email: json['parent']['email'],
        name: json['parent']['name'],
        nickname: json['parent']['nickname'],
        gender: Parent.setGender(json['parent']['gender']),
        signInMethod: Parent.setSignInMethod(json['parent']['signInMethod']),
        emailVerified: json['parent']['emailVerified'],
        photoId: json['parent']['photoId'],
        description: json['parent']['description'],
        mainAddr: json['parent']['mainAddr'],
        subAddr: json['parent']['subAddr'],
        hashList: json['parent']['hashList'],
        jwt: json['x-jwt']['access_token'],
      );
      return parent;
    } catch (e) {
      print("GetParent Error");
      print(e);
      return null;
    }
  }
}
