import 'dart:convert';
import 'dart:io';

import 'package:babystory/models/baby.dart';
import 'package:babystory/models/parent.dart';
import 'package:babystory/utils/http.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CreateBabyInput {
  final String name;
  final DateTime birthDate;
  final String? genderString;
  final String? bloodTypeString;
  final String? photoUrl;

  CreateBabyInput({
    required this.name,
    required this.birthDate,
    this.genderString,
    this.bloodTypeString,
    this.photoUrl,
  });

  Map<String, String> getMap({includePhotoUrl = false}) {
    Map<String, String> dict = {
      "name": name,
      "birthDate": birthDate.toIso8601String(),
    };
    if (genderString != null) {
      dict['gender'] = genderString!;
    }
    if (bloodTypeString != null) {
      dict['bloodType'] = bloodTypeString!;
    }
    if (photoUrl != null && includePhotoUrl) {
      dict['photoId'] = photoUrl!;
    }
    return dict;
  }
}

class BabyApi {
  final HttpUtils httpUtils = HttpUtils();

  Future<List<Baby>> getBabies({required Parent parent}) async {
    try {
      var jwt = parent.jwt;
      if (jwt == null) {
        debugPrint('uid is null in getBabies');
        return [];
      }

      var json = await httpUtils
          .get(url: '/baby/all', headers: {'Authorization': 'Bearer $jwt'});
      if (json == null) {
        return [];
      }

      return List.generate(json.length, (i) => Baby.fromJson(json[i], parent));
    } catch (e) {
      debugPrintStack();
      return [];
    }
  }

  Future<Baby?> createBaby(
      {required CreateBabyInput createBabyInput,
      required Parent parent}) async {
    try {
      var json = await httpUtils.postMultipart(
        url: '/baby/create',
        headers: {'Authorization': 'Bearer ${parent.jwt ?? ''}'},
        fields: createBabyInput.getMap(),
        filePath: createBabyInput.photoUrl,
      );
      if (json == null) {
        print("Get null response");
        return null;
      }
      return Baby.fromJson(json, parent);
    } catch (e) {
      debugPrintStack();
      print(e);
      return null;
    }
  }
}
