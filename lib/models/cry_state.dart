import 'package:flutter/foundation.dart';

enum CryIntensity { low, medium, high }

List<String> CryIntensityList = CryIntensity.values.map((e) => e.name).toList();

CryIntensity getCryIntensityFromString(String intensity) {
  switch (intensity) {
    case 'low':
      return CryIntensity.low;
    case 'medium':
      return CryIntensity.medium;
    case 'high':
      return CryIntensity.high;
    default:
      return CryIntensity.medium;
  }
}

enum CryType { sad, hug, diaper, hungry, sleepy, awake, uncomfortable }

List<String> CryTypeList = CryType.values.map((e) => e.name).toList();

CryType getCryTypeFromString(String type) {
  switch (type) {
    case 'sad':
      return CryType.sad;
    case 'hug':
      return CryType.hug;
    case 'diaper':
      return CryType.diaper;
    case 'hungry':
      return CryType.hungry;
    case 'sleepy':
      return CryType.sleepy;
    case 'awake':
      return CryType.awake;
    case 'uncomfortable':
      return CryType.uncomfortable;
    default:
      return CryType.uncomfortable;
  }
}

class CryState {
  late DateTime time;
  late CryType type;
  late CryIntensity intensity;
  late String? audioURL;
  late Map<String, double> predictMap;

  double? duration;
  int? id;

  CryState({
    required this.time,
    required this.type,
    required this.intensity,
    required this.predictMap,
    this.audioURL,
    this.duration,
    this.id,
  });

  CryState.fromJson(Map<String, dynamic> json) {
    print("received json: ");
    print(json);
    time = DateTime.parse(json['time']);
    predictMap = _getTypeFromStateMap(json['predictMap']);
    type = getCryTypeFromString(predictMap.keys.toList()[0]);
    intensity = getCryIntensityFromString(json['intensity']);
    audioURL = json['audioId'];
    duration = json['duration'];
    id = json['id'];
  }

  //return type of CryState as String
  String getType() {
    return describeEnum(type);
  }

  Map<String, double> _getTypeFromStateMap(Map<String, dynamic> stateMap) {
    Map<String, double> tempPredictMap = {};
    var keys = stateMap.keys.toList();

    while (keys.isNotEmpty) {
      String maxKey = keys[0];
      for (var key in keys) {
        if (stateMap[key]! > stateMap[maxKey]!) {
          maxKey = key;
        }
      }
      tempPredictMap[maxKey] = stateMap[maxKey];
      stateMap.remove(maxKey);
      keys.remove(maxKey);
    }
    return tempPredictMap;
  }

  Map<String, double> getPredictMap({int? limit}) {
    var keys = predictMap.keys.toList();
    limit ??= keys.length;

    Map<String, double> returnMap = {};
    for (var i = 0; i < limit; i++) {
      returnMap[keys[i]] = predictMap[keys[i]]!;
    }
    return returnMap;
  }

  void printBabyState() {
    print('time: $time');
    print('type: $type');
    print('intensity: $intensity');
    print('predictMap: $predictMap');
    print('audioURL: $audioURL');
    print('duration: $duration');
    print('id: $id');
  }

  void printInfo() {
    printBabyState();
  }
}
