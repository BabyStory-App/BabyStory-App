import 'package:babystory/models/baby_state_record.dart';
import 'package:babystory/models/cry_state.dart';
import 'package:babystory/models/parent.dart';

enum Gender {
  male,
  female,
  unknown,
}

List<String> GenderList = Gender.values.map((e) => e.name).toList();

Gender getGenderFromString(String gender) {
  switch (gender) {
    case 'male':
      return Gender.male;
    case 'female':
      return Gender.female;
    case 'unknown':
      return Gender.unknown;
    default:
      return Gender.unknown;
  }
}

enum BloodType {
  a,
  b,
  o,
  ab,
  unknown,
}

List<String> BloodTypeList = BloodType.values.map((e) => e.name).toList();

BloodType getBloodTypeFromString(String bloodType) {
  switch (bloodType) {
    case 'a':
      return BloodType.a;
    case 'b':
      return BloodType.b;
    case 'o':
      return BloodType.o;
    case 'ab':
      return BloodType.ab;
    case 'unknown':
      return BloodType.unknown;
    default:
      return BloodType.unknown;
  }
}

class Baby {
  late String name;
  late Gender gender;
  late DateTime birthDate;
  late Parent parent;
  late BabyStateRecord state;
  late BloodType bloodType;
  late List<BabyStateRecord> stateRecords;
  late List<CryState> cryStates;
  late String? photoId;

  Baby({
    required this.name,
    required this.birthDate,
    required this.parent,
    required this.state,
    this.gender = Gender.unknown,
    this.bloodType = BloodType.unknown,
    this.stateRecords = const [],
    this.cryStates = const [],
    this.photoId,
  }) {
    stateRecords = List<BabyStateRecord>.empty();
    cryStates = List<CryState>.empty();
  }

  Baby.fromJson(Map<String, dynamic> json, Parent parent) {
    var curdate = DateTime.parse(json['birthDate']);
    name = json['name'];
    birthDate = curdate;
    // ignore: prefer_initializing_formals
    this.parent = parent;
    state = BabyStateRecord(
        recordDate: curdate,
        title: '',
        description: '',
        photoURL: json['photoId'] == null ? [] : [json['photoId']]);
    gender = getGenderFromString(json['gender']);
    bloodType = getBloodTypeFromString(json['bloodType']);
    stateRecords = [];
    cryStates = [];
    photoId = json['photoId'];
  }

  // print all infomation of baby
  void printInfo() {
    print('name: $name');
    print('gender: $gender');
    print('birthDate: $birthDate');
    print('photoId: $photoId');
    print("parent:");
    parent.printInfo();
    print('state: ');
    state.printInfo();
    print('bloodType: $bloodType');
    print('${stateRecords.length} sdtateRecords exists: ');
    for (int i = 0; i < stateRecords.length; i++) {
      stateRecords[i].printInfo();
    }
    print('cryStates: $cryStates');
  }
}
