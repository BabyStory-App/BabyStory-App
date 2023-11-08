import 'package:babystory/models/baby_state_record.dart';
import 'package:babystory/models/cry_state.dart';
import 'package:babystory/models/perent.dart';

enum Gender {
  male,
  female,
  unknown,
}

List<String> GenderList = Gender.values.map((e) => e.name).toList();

enum BloodType {
  a,
  b,
  o,
  ab,
  unknown,
}

List<String> BloodTypeList = BloodType.values.map((e) => e.name).toList();

class Baby {
  String name;
  Gender gender;
  DateTime birthDate;
  Perent perent;
  BabyStateRecord state;
  BloodType bloodType;
  List<BabyStateRecord> stateRecords;
  List<CryState> cryStates;

  Baby({
    required this.name,
    required this.birthDate,
    required this.perent,
    required this.state,
    this.gender = Gender.unknown,
    this.bloodType = BloodType.unknown,
    this.stateRecords = const [],
    this.cryStates = const [],
  }) {
    stateRecords = List<BabyStateRecord>.empty();
    cryStates = List<CryState>.empty();
  }
}
