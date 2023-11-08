class BabyStateRecord {
  final DateTime recordDate;
  String title;
  String description;
  double? weight;
  double? height;
  double? headCircumference;
  List<String> photoURL;

  BabyStateRecord({
    required this.recordDate,
    required this.title,
    required this.description,
    this.weight,
    this.height,
    this.headCircumference,
    this.photoURL = const [],
  }) {
    photoURL = List<String>.empty();
  }
}
