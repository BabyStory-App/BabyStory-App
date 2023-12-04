import 'dart:convert';
import 'dart:io';

import 'package:babystory/models/baby.dart';
import 'package:babystory/models/cry_state.dart';
import 'package:babystory/utils/http.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CryApi {
  final HttpUtils httpUtils = HttpUtils();

  Future<List<CryState>> getCries(
      {required Baby baby, DateTime? startDate, DateTime? endDate}) async {
    startDate ??= DateTime.now().subtract(const Duration(days: 7));
    endDate ??= DateTime.now();

    try {
      var jwt = baby.parent.jwt;
      if (jwt == null) {
        debugPrint('uid is null in getCries');
        return [];
      }

      var json = await httpUtils.get(url: '/cry/all', headers: {
        'Authorization': 'Bearer $jwt',
        'start': startDate.toIso8601String(),
        'end': endDate.toIso8601String(),
        'babyId': baby.id ?? '',
      });
      if (json == null) {
        return [];
      }

      return List.generate(json.length, (i) => CryState.fromJson(json[i]));
    } catch (e) {
      debugPrint('Error in getCries: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> inspect({required Baby baby}) async {
    try {
      var jwt = baby.parent.jwt;
      if (jwt == null) {
        debugPrint('uid is null in inspect');
        return {};
      }

      var json = await httpUtils.get(url: '/cry/inspect', headers: {
        'Authorization': 'Bearer $jwt',
        'babyId': baby.id ?? '',
      });
      if (json == null) {
        return {};
      }

      return json;
    } catch (e) {
      debugPrint('Error in inspect: $e');
      return {};
    }
  }
}
