import 'package:babystory/utils/http.dart';
import 'package:flutter/material.dart';

class FriendApi {
  final HttpUtils httpUtils = HttpUtils();

  Future<bool> toggleFriend({
    required String jwt,
    required String friendUid,
  }) async {
    try {
      var json = await httpUtils.post(url: '/friend/', body: {
        'friend': friendUid,
      });
      if (json == null) {
        debugPrint('toggleFriend failed');
        return false;
      }
      return json['hasCreated'] == true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
