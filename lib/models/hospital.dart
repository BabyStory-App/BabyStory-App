class Hospital {
  final int id;
  final int diaryId;
  final String babyId;
  final DateTime createTime;
  final DateTime? modifyTime;
  final double parentKg;
  final double pressure;
  final double? babyKg;
  final int? babyCm;
  final Map<String, dynamic>? special;
  final DateTime? nextDay;

  Hospital({
    required this.id,
    required this.diaryId,
    required this.babyId,
    required this.createTime,
    this.modifyTime,
    required this.parentKg,
    required this.pressure,
    this.babyKg,
    this.babyCm,
    this.special,
    this.nextDay,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      id: json['hospital_id'],
      diaryId: json['diary_id'],
      babyId: json['baby_id'],
      createTime: DateTime.parse(json['createTime']),
      modifyTime: json['modifyTime'] != null
          ? DateTime.parse(json['modifyTime'])
          : null,
      parentKg: json['parent_kg'],
      pressure: json['bpressure'],
      babyKg: json['baby_kg'],
      babyCm: json['baby_cm'],
      special: json['special'],
      nextDay:
          json['next_day'] != null ? DateTime.parse(json['next_day']) : null,
    );
  }
}
