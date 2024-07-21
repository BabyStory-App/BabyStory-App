enum ChatType { text, image, video, audio, file, location, icon }

ChatType parseChatType(String chatType) {
  switch (chatType) {
    case 'text':
      return ChatType.text;
    case 'image':
      return ChatType.image;
    case 'video':
      return ChatType.video;
    case 'audio':
      return ChatType.audio;
    case 'file':
      return ChatType.file;
    case 'location':
      return ChatType.location;
    case 'icon':
      return ChatType.icon;
    default:
      throw ArgumentError('Invalid chat type');
  }
}

class Chat {
  final int id;
  final String parentId;
  final int roomId;
  final DateTime createTime;
  final ChatType chatType;
  final String content;

  Chat({
    required this.id,
    required this.parentId,
    required this.roomId,
    required this.createTime,
    required this.chatType,
    required this.content,
  });

  // from json
  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['chat_id'],
      parentId: json['parent_id'],
      roomId: json['room_id'],
      createTime: DateTime.parse(json['createTime']),
      chatType: parseChatType(json['chatType']),
      content: json['content'],
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'chat_id': id,
      'parent_id': parentId,
      'room_id': roomId,
      'createTime': createTime.toIso8601String(),
      'chatType': chatType.index,
      'content': content,
    };
  }
}
