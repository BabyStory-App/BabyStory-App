import 'package:babystory/enum/gender.dart';

class Baby {
  final String id;
  final String obn; // 태명
  String? name;
  Gender gender;
  DateTime? birthDate;
  String? bloodType;
  double? cm;
  double? kg;
  String? photoId;

  Baby({
    required this.id,
    required this.obn,
    this.name,
    this.gender = Gender.unknown,
    this.birthDate,
    this.bloodType,
    this.cm,
    this.kg,
    this.photoId,
  });

  factory Baby.fromJson(Map<String, dynamic> json) {
    return Baby(
      id: json['baby_id'],
      obn: json['obn'],
      name: json['name'],
      gender: matchGender(json['gender']),
      birthDate:
          json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null,
      bloodType: json['bloodType'],
      cm: json['cm'] != null ? (json['cm'] as num).toDouble() : null,
      kg: json['kg'] != null ? (json['kg'] as num).toDouble() : null,
      photoId: json['photoId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'baby_id': id,
      'obn': obn,
      'name': name,
      'gender': gender.index,
      'birthDate': birthDate?.toIso8601String(),
      'bloodType': bloodType,
      'cm': cm,
      'kg': kg,
      'photoId': photoId,
    };
  }
}
