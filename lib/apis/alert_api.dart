import 'package:babystory/models/alert.dart';
import 'package:babystory/utils/http.dart';

class AlertApi {
  final HttpUtils httpUtils = HttpUtils();
  final String jwt;

  AlertApi({required this.jwt});

  Future<List<AlertMsg>> getAlerts() async {
    try {
      var json = await httpUtils
          .get(url: '/alert/', headers: {'Authorization': 'Bearer $jwt'});
      print("Response: $json");
      if (json == null || json['alerts'] == null) {
        return [];
      }
      return List<AlertMsg>.from(
          json['alerts'].map((x) => AlertMsg.fromJson(x)));
    } catch (e) {
      print(e);
      return [];
    }
  }

  void checkMsg(List<int> ids) async {
    if (ids.isEmpty) return;
    try {
      await httpUtils.get(
          url: '/alert/checked/${ids.join(',')}',
          headers: {'Authorization': 'Bearer $jwt'});
    } catch (e) {
      print(e);
    }
  }
}
