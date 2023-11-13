import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:babystory/services/detect_cry.dart';
import 'package:record/record.dart';

class RecordService {
  bool _hasLoadModel = false;
  late DetectCryService detectCry;

  RecordService() {
    detectCry = DetectCryService(
        modelPath: 'assets/models/lite-model_yamnet_tflite_1.tflite',
        csvPath: 'assets/models/yamnet_class_map.csv');
  }

  Future<bool> waitSound(String filePath, Function stopCallback) async {
    final record = Record();

    if (await record.hasPermission() == false) {
      throw "Does not have any permission to record";
    }

    if (_hasLoadModel == false) {
      await detectCry.loadModelAsset();
      _hasLoadModel = true;
    }

    while (true) {
      debugPrint("Start recording");

      final file = File(filePath);

      // 파일이 존재할 경우 삭제한다.
      if (file.existsSync()) {
        debugPrint("delete file");
        file.deleteSync();
      }

      // Start recording
      await record.start(
        path: filePath,
        encoder: AudioEncoder.wav,
        bitRate: 128000,
        samplingRate: 16000,
      );

      await Future.delayed(const Duration(seconds: 3));

      debugPrint("Stop recording");
      await record.stop();

      // 아이의 울음소리인지 판단한다.
      bool isBabyCry = await detectCry.isBabyCry(filePath);
      debugPrint("isBabyCry: $isBabyCry");

      // 모든 작업을 완료했음에도 사용자가 듣는 것을 멈추면 작업을 끝낸다.
      if (stopCallback() == false) {
        debugPrint("User prase stop");
        return false;
      }

      if (isBabyCry) return true;
    }
  }
}
