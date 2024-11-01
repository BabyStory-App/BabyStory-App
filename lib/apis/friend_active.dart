import 'package:babystory/utils/http.dart';

class FriendActive {
  final HttpUtils httpUtils = HttpUtils();
  final String jwt;
  final String friendUid;

  FriendActive({
    required this.jwt,
    required this.friendUid,
  });

  Future<bool> getAlertStatus() async {
    try {
      var json = await httpUtils.get(
          url: '/alert/hasSubscribe/$friendUid',
          headers: {'Authorization': 'Bearer $jwt'});
      if (json != null) {
        return json['state'] == true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> toggleAlert() async {
    try {
      var json = await httpUtils.get(
          url: '/alert/subscribe/$friendUid',
          headers: {'Authorization': 'Bearer $jwt'});
      if (json != null) {
        return json['hasSubscribe'] == true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> getFriendStatus() async {
    try {
      var json = await httpUtils.get(
          url: '/friend/isFriend/$friendUid/',
          headers: {'Authorization': 'Bearer $jwt'});
      if (json != null) {
        return json['state'] == true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> toggleFriend() async {
    try {
      var json = await httpUtils.post(url: '/friend/', headers: {
        'Authorization': 'Bearer $jwt'
      }, body: {
        'friend': friendUid,
      });
      if (json == null) {
        return false;
      }
      return json['hasCreated'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<List<bool>> getAlertAndFriendStatus() async {
    return await Future.wait([getAlertStatus(), getFriendStatus()]);
  }
}
