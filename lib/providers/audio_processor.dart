import 'package:babystory/services/notification.dart';
import 'package:babystory/services/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class AudioProcessor {
  late RecordService _recordService;
  late NotificationService _notificationService;
  final bool Function() isListening;

  AudioProcessor({
    required this.isListening,
  }) {
    _recordService = RecordService();
    _notificationService = NotificationService();
  }

  Future<void> waitForSoundAndAnalyze({
    required Function() onAnalysisStarted,
    required Function(String) onAnalysisComplete,
  }) async {
    var dir = (await getApplicationDocumentsDirectory()).path;
    var filePath = '$dir/tempRecord.wav';

    bool hasDetected = await _recordService.waitSound(filePath, isListening);

    if (hasDetected && isListening()) {
      _notificationService.showNotification(
          'BabyStory', '아이가 울고 있어요! 원인을 분석중입니다...');
      onAnalysisStarted();
      await Future.delayed(const Duration(seconds: 1));
      try {
        onAnalysisComplete(filePath);
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }
}
