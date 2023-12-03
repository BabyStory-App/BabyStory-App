import 'dart:convert';
import 'dart:io';
import 'package:babystory/models/cry_state.dart';
import 'package:flutter/material.dart';
import 'package:babystory/utils/os.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RawsApi {
  static String baseroot = dotenv.env['API_BASE_ROOT'] ?? '';
  static String getProfileLink(String? fileId) {
    return "$baseroot/raws/profile/${fileId ?? 'default_profile_image'}";
  }
}
