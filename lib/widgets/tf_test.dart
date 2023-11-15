import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

class TfTest extends StatefulWidget {
  const TfTest({super.key});

  @override
  State<TfTest> createState() => _TfTestState();
}

class _TfTestState extends State<TfTest> {
  final String modelPath =
      'assets/models/lite-model_yamnet_classification_tflite_1.tflite';
  final String csvPath = 'assets/models/yamnet_class_map.csv';
  late tfl.Interpreter interpreter;

  @override
  void initState() {
    super.initState();
    loadModelAsset();
  }

  @override
  void dispose() {
    interpreter.close();
    super.dispose();
  }

  Future<void> loadModelAsset() async {
    interpreter = await tfl.Interpreter.fromAsset(modelPath);

    print(interpreter.runtimeType);
    if (interpreter.runtimeType == Null) {
      print('interpreter is null');
    }

    var inputTensor = interpreter.getInputTensor(0);
    var inputShape = inputTensor.shape;
    var inputType = inputTensor.type;
    print("Input shape: $inputShape");
    print("Input type: $inputType");

    var outputTensor = interpreter.getOutputTensor(0);
    var outputShape = outputTensor.shape;
    var outputType = outputTensor.type;
    print("\nOutput shape: $outputShape");
    print("Output type: $outputType\n");
  }

  Future<void> predict() async {
    var input = List<double>.filled(48000, Random.secure().nextDouble());
    // var output = List.generate(6, (index) => List<double>.filled(521, 0.0));
    var output = [List<double>.filled(521, 0.0)];

    print(input.length); // 1
    // print(input[0].length); // 48000
    print(input.runtimeType); // List<List<dynamic>>
    print(input[0].runtimeType); // List<dynamic>
    print("");
    print(output.length);
    print(output[0].length);
    print(output.runtimeType);
    print(output[0].runtimeType);

    // inference
    interpreter.run(input, output);
    try {} catch (e) {
      print("ERROR");
      print(e);
    }

    print("output");
    print(output.length);
    print(output);
    // print the output
    var classes = await getYamNetClasses();
    var predictMap = _getNameFromScore(classes, output[0], 5);
    printScoreMap(predictMap);
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

  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await predict();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: TextButton(
      onPressed: () => main(),
      child: const Text("Click", style: TextStyle(fontSize: 32)),
    ));
  }
}
