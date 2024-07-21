class Alert {
  final int id;
  final String parentId;
  final String target; // 알림 온 종류 (팔로우, 게시물 하트 등)
  final String message;
  bool click; // 알림 클릭 여부

  Alert({
    required this.id,
    required this.parentId,
    required this.target,
    required this.message,
    this.click = false,
  });

  // from json
  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['alert_id'],
      parentId: json['parent_id'],
      target: json['target'],
      message: json['message'],
      click: json['click'],
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'alert_id': id,
      'parent_id': parentId,
      'target': target,
      'message': message,
      'click': click,
    };
  }
}
