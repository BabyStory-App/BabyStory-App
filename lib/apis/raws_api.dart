import 'dart:io';
import 'package:babystory/utils/os.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';

class RawsApi {
  static String baseroot = dotenv.env['API_BASE_ROOT'] ?? '';

  static String getProfileLink(String? fileId) {
    if (fileId != null && fileId.contains('http')) {
      return fileId;
    }
    return "$baseroot/raws/profile/${fileId ?? 'default_profile_image'}";
  }

  static String getCryLink(String? audioId) {
    return "request cry: ${'$baseroot/raws/cry/${audioId ?? "sample"}'}";
  }

  static Future<String> getCry(String? audioId) async {
    try {
      var response = await http.get(Uri.parse('$baseroot/raws/cry/$audioId'));
      if (response.statusCode == 200) {
        var bytes = response.bodyBytes;

        String dir = (await getApplicationDocumentsDirectory()).path;
        var fileDir = '$dir/downloadCryFileTemp.wav';

        if (OsUtils.isFileExist(fileDir)) {
          await OsUtils.deleteFile(fileDir);
        }

        File file = File(fileDir);
        await file.writeAsBytes(bytes);

        return fileDir;
      }
      return '';
    } catch (e) {
      debugPrint(e.toString());
      return '';
    }
  }
}
