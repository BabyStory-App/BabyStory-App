class AIDoctor {
  final int id;
  final String parentId;
  final DateTime createTime;
  final String ask;
  final String res;
  String? hAddr; // 병원 주소

  AIDoctor({
    required this.id,
    required this.parentId,
    required this.createTime,
    required this.ask,
    required this.res,
    this.hAddr,
  });

  // from json
  factory AIDoctor.fromJson(Map<String, dynamic> json) {
    return AIDoctor(
      id: json['ai_id'],
      parentId: json['parent_id'],
      createTime: DateTime.parse(json['createTime']),
      ask: json['ask'],
      res: json['res'],
      hAddr: json['hAddr'],
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'ai_id': id,
      'parent_id': parentId,
      'createTime': createTime.toIso8601String(),
      'ask': ask,
      'res': res,
      'hAddr': hAddr,
    };
  }
}
