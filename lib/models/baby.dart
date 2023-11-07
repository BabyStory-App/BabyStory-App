import 'package:babystory/models/baby_state_record.dart';
import 'package:babystory/models/perent.dart';

enum Gender {
  male,
  female,
  unknown,
}

class Baby {
  String name;
  int monthAge;
  Gender gender;
  DateTime birthDate;
  Perent perent;
  BabyStateRecord state;
  List<BabyStateRecord> stateRecords;

  Baby({
    required this.name,
    required this.monthAge,
    required this.gender,
    required this.birthDate,
    required this.perent,
    required this.state,
    this.stateRecords = const [],
  });
}
