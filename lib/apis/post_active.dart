import 'package:babystory/utils/http.dart';

class PostActive {
  final HttpUtils httpUtils = HttpUtils();
  final String jwt;
  final int postId;

  PostActive({
    required this.jwt,
    required this.postId,
  });

  Future<bool> _requestActive(String url) async {
    try {
      var json = await httpUtils.post(url: url, headers: {
        'Authorization': 'Bearer $jwt'
      }, body: {
        'post_id': postId,
      });
      if (json != null) {
        return json['hasCreated'] == true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _requestStatus(String url) async {
    try {
      var json = await httpUtils
          .get(url: '$url$postId', headers: {'Authorization': 'Bearer $jwt'});
      if (json != null) {
        return json['state'] == true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> getHeartStatus() async {
    return await _requestStatus('/pheart/hasHeart/');
  }

  Future<bool> getScriptStatus() async {
    return await _requestStatus('/pscript/hasScript/');
  }

  Future<List<bool>> getHeartAndScriptStatus() async {
    return await Future.wait([getHeartStatus(), getScriptStatus()]);
  }

  Future<bool> toggleHeart() async {
    return await _requestActive('/pheart/');
  }

  Future<bool> toggleScript() async {
    return await _requestActive('/pscript/');
  }

  Future<bool> toggleView() async {
    return await _requestActive('/pview/');
  }
}
