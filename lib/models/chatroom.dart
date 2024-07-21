class ChatRoom {
  final int id;
  final String createrId;
  final String name;
  String lastChat; // 가장 최근 채팅: 서버로부터 받는 것이 아닌 클라에서 계산.

  ChatRoom({
    required this.id,
    required this.createrId,
    required this.name,
    this.lastChat = '',
  });

  // from json
  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['room_id'],
      createrId: json['parent_id'],
      name: json['name'],
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'room_id': id,
      'parent_id': createrId,
      'lastChat': lastChat,
      'name': name,
    };
  }
}
