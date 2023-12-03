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

  void printInfo() {
    print('recordDate: $recordDate');
    print('title: $title');
    print('description: $description');
    print('weight: $weight');
    print('height: $height');
    print('headCircumference: $headCircumference');
    print('photoURL: $photoURL');
  }
}
