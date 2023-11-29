import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HttpUtils {
  late String baseroot;

  HttpUtils() {
    baseroot = dotenv.env['API_BASE_ROOT'] ?? '';
  }

  Future<Map<String, dynamic>?> get({
    required String url,
    Map<String, String>? headers,
    Map<String, String>? querys,
  }) async {
    headers ??= {};
    querys ??= {};
    try {
      var uri = Uri.parse('$baseroot$url');
      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        ...headers,
      });
      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
      return null;
    } catch (e) {
      debugPrintStack();
      debugPrint(e.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>?> post({
    required String url,
    Map<String, String>? headers,
    Map<String, String>? querys,
    Map<String, dynamic>? body,
  }) async {
    headers ??= {};
    querys ??= {};
    body ??= {};
    try {
      var uri = Uri.parse('$baseroot$url');
      final response = await http.post(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            // HttpHeaders.acceptCharsetHeader: 'utf-8',
            ...headers,
          },
          body: jsonEncode(body));
      if (response.statusCode == 201) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
      return null;
    } catch (e) {
      debugPrintStack();
      debugPrint(e.toString());
      return null;
    }
  }
}
