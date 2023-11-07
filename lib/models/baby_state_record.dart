import 'package:babystory/models/cry_state.dart';

class BabyStateRecord {
  final DateTime recordDate;
  double? weight;
  double? height;
  double? headCircumference;
  List<String>? photoURL;
  CryState? cryState;

  BabyStateRecord({
    required this.recordDate,
    this.weight,
    this.height,
    this.headCircumference,
    this.photoURL,
    this.cryState,
  });
}
