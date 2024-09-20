import 'package:babystory/enum/gender.dart';

List<String> bloodTypeList = [
  ' A+',
  ' B+',
  'AB+',
  ' O+',
  ' A-',
  ' B-',
  'AB-',
  ' O-'
];

class Baby {
  final String id;
  String obn; // 태명
  String? name;
  Gender gender;
  DateTime birthDate;
  String bloodType;
  double? cm;
  double? kg;
  String? photoId;

  Baby(
      {required this.id,
      required this.obn,
      this.name,
      this.gender = Gender.unknown,
      required this.birthDate,
      required this.bloodType,
      this.cm,
      this.kg,
      this.photoId});

  factory Baby.fromJson(Map<String, dynamic> json) {
    return Baby(
        id: json['baby_id'],
        obn: json['obn'],
        name: json['name'],
        gender: matchGender(json['gender']),
        birthDate: DateTime.parse(json['birthDate']),
        bloodType: json['bloodType'],
        cm: json['cm'] != null ? (json['cm'] as num).toDouble() : null,
        kg: json['kg'] != null ? (json['kg'] as num).toDouble() : null,
        photoId: json['photoId']);
  }

  void updateProfile(String key, dynamic value) {
    switch (key) {
      case 'name':
        name = value;
        break;
      case 'obn':
        obn = value;
        break;
      case 'gender':
        var tempGender = Gender.unknown;
        switch (value) {
          case "남성":
            tempGender = Gender.male;
            break;
          case "여성":
            tempGender = Gender.female;
            break;
        }
        gender = tempGender;
        break;
      case 'birthDate':
        birthDate = value;
        break;
      case 'bloodType':
        bloodType = value;
        break;
      case 'cm':
        cm = value;
        break;
      case 'kg':
        kg = value;
        break;
      case 'photoId':
        photoId = value;
        break;
    }
  }

  Baby copyWith({
    String? id,
    String? obn,
    String? name,
    Gender? gender,
    DateTime? birthDate,
    String? bloodType,
    double? cm,
    double? kg,
    String? photoId,
  }) {
    return Baby(
        id: id ?? this.id,
        obn: obn ?? this.obn,
        name: name ?? this.name,
        gender: gender ?? this.gender,
        birthDate: birthDate ?? this.birthDate,
        bloodType: bloodType ?? this.bloodType,
        cm: cm ?? this.cm,
        kg: kg ?? this.kg,
        photoId: photoId ?? this.photoId);
  }

  Map<String, dynamic> toJson() {
    return {
      'baby_id': id,
      'obn': obn,
      'name': name,
      'gender': gender.index,
      'birthDate': birthDate.toIso8601String(),
      'bloodType': bloodType,
      'cm': cm,
      'kg': kg,
      'photoId': photoId,
    };
  }

  void printInfo() {
    print(
        "Baby(\n\tid: $id,\n\tobn: $obn,\n\tname: $name,\n\tgender: ${genderToString(gender)},\n\tbirthDate: ${birthDate.toString()},\n\tbloodType: $bloodType,\n\tcm: $cm,\n\tkg: $kg,\n\tphotoId: $photoId\n);");
  }
}
