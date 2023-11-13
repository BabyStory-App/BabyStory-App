import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:flutter/services.dart';
import 'package:wav/wav.dart';

class DetectCryService {
  late String modelPath = '';
  late String csvPath = '';
  late tfl.Interpreter interpreter;
  static const List<String> babyClasses = ['Crying', 'Baby cry'];

  DetectCryService({required this.modelPath, required this.csvPath});

  Future<void> loadModelAsset() async {
    interpreter = await tfl.Interpreter.fromAsset(modelPath);
  }

  Future<bool> isBabyCry(String filePath) async {
    var input = await readWav(filePath);
    var output = List.filled(1, List.filled(521, 0.0));

    // inference
    interpreter.run(input, output);

    // print the output
    var classes = await getYamNetClasses();
    var predictMap = _getNameFromScore(classes, output[0], 5);
    printScoreMap(predictMap);
    return defineCryByPrediction(predictMap);
  }

  Future<List<double>> readWav(String filePath) async {
    final wav = await Wav.readFile(filePath);
    var mono = wav.toMono();

    return mono;
  }

  Future<List<String>> getYamNetClasses() async {
    String fileContent = await rootBundle.loadString(csvPath);

    List<String> lines = fileContent.split('\n');

    // 첫 번째 줄 (헤더)를 제거
    lines.removeAt(0);

    // 빈 줄 제거
    lines.removeWhere((line) => line.trim().isEmpty);

    // display_name만 추출
    List<String> displayNames = lines.map((line) {
      List<String> columns = line.split(',');
      String displayName = columns[2];

      // 쌍따옴표가 포함된 경우 제거
      return displayName.replaceAll('"', '').trim();
    }).toList();

    return displayNames;
  }

  bool defineCryByPrediction(Map<String, double> predictMap) {
    var targetList = predictMap.keys.toList();

    for (String target in targetList) {
      if (babyClasses.contains(target)) {
        return true;
      }
    }
    return false;
  }

  Map<String, double> _getNameFromScore(
      List<String> classes, List<double> prediction, int n) {
    var indexedPrediction = prediction.asMap().entries.toList();

    indexedPrediction.sort((a, b) => b.value.compareTo(a.value));

    Map<String, double> sortedMap = Map.fromEntries(indexedPrediction
        .take(n)
        .map((entry) => MapEntry(classes[entry.key], entry.value)));

    return sortedMap;
  }

  void printScoreMap(Map<String, double> predictMap) {
    predictMap.forEach((key, value) {
      debugPrint('$key: ${value.toStringAsFixed(2)}');
    });
  }
}
