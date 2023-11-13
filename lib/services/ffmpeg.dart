import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

class FfmpegService {
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

  Future<bool> trimAudio(inputPath, outputPath) async {
    try {
      final int resultCode = await _flutterFFmpeg
          .execute('-i $inputPath -t 2 -c copy $outputPath');
      return resultCode == 0;
    } catch (e) {
      return false;
    }
  }
}
