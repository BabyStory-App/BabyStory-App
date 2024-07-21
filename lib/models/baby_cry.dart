import 'package:flutter/foundation.dart';
import 'package:babystory/enum/cry_intensity.dart';
import 'package:babystory/enum/cry_type.dart';

class Babycry {
  final int id;
  final String babyId;
  final DateTime createTime;
  final String cryType;
  final String audioId;
  final Map<String, double> predictMap;
  final CryIntensity intensity;
  final double duration;

  Babycry({
    required this.id,
    required this.babyId,
    required this.createTime,
    required this.cryType,
    required this.audioId,
    required this.predictMap,
    required this.intensity,
    required this.duration,
  });

  // from json
  factory Babycry.fromJson(Map<String, dynamic> json) {
    return Babycry(
      id: json['babycry_id'],
      babyId: json['baby_id'],
      createTime: DateTime.parse(json['createTime']),
      cryType: json['cryType'],
      audioId: json['audioId'],
      // predictMap: Map<String, double>.from(json['predictMap']),
      predictMap: getCryTypeFromStateMap(json['predictMap']),
      intensity: matchIntensity(json['intensity']),
      duration: json['duration'].toDouble(),
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'babycry_id': id,
      'baby_id': babyId,
      'createTime': createTime.toIso8601String(),
      'cryType': cryType,
      'audioId': audioId,
      'predictMap': predictMap,
      'intensity': intensity.index,
      'duration': duration,
    };
  }

  //return type of CryState as String
  String getType() {
    return describeEnum(cryType);
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
    print('id: $id');
    print('babyId: $babyId');
    print('createTime: $createTime');
    print('cryType: $cryType');
    print('audioId: $audioId');
    print('predictMap: $predictMap');
    print('intensity: $intensity');
    print('duration: $duration');
  }

  void printInfo() {
    printBabyState();
  }
}
