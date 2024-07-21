class Comment {
  final int id;
  final String parentId;
  final int postId;
  int? replyId;
  final String content;
  final DateTime createTime;
  DateTime? modifyTime;
  DateTime? deleteTime;
  int? cheart;

  Comment({
    required this.id,
    required this.parentId,
    required this.postId,
    this.replyId,
    required this.content,
    required this.createTime,
    this.modifyTime,
    this.deleteTime,
    this.cheart,
  });

  // from json
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['comment_id'],
      parentId: json['parent_id'],
      postId: json['post_id'],
      replyId: json['reply_id'],
      content: json['content'],
      createTime: DateTime.parse(json['createTime']),
      modifyTime: json['modifyTime'] != null
          ? DateTime.parse(json['modifyTime'])
          : null,
      deleteTime: json['deleteTime'] != null
          ? DateTime.parse(json['deleteTime'])
          : null,
      cheart: json['cheart'],
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'comment_id': id,
      'parent_id': parentId,
      'post_id': postId,
      'reply_id': replyId,
      'content': content,
      'createTime': createTime.toIso8601String(),
      'modifyTime': modifyTime?.toIso8601String(),
      'deleteTime': deleteTime?.toIso8601String(),
      'cheart': cheart,
    };
  }
}
