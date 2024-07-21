class Babystate {
  final int id;
  final String babyId;
  final DateTime createTime;
  final double cm;
  final double kg;

  Babystate({
    required this.id,
    required this.babyId,
    required this.createTime,
    required this.cm,
    required this.kg,
  });

  // from json
  factory Babystate.fromJson(Map<String, dynamic> json) {
    return Babystate(
      id: json['state_id'],
      babyId: json['baby_id'],
      createTime: DateTime.parse(json['createTime']),
      cm: json['cm'].toDouble(),
      kg: json['kg'].toDouble(),
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'state_id': id,
      'baby_id': babyId,
      'createTime': createTime.toIso8601String(),
      'cm': cm,
      'kg': kg,
    };
  }
}
