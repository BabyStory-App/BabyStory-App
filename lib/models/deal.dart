class Deal {
  final int id;
  final String parentId;
  final String title;
  String? content;
  final String photoId;
  final int price;
  final DateTime createTime;
  final int dheart; // 좋아요 수
  final int dview; // 조회수

  Deal({
    required this.id,
    required this.parentId,
    required this.title,
    this.content,
    required this.photoId,
    required this.price,
    required this.createTime,
    required this.dheart,
    required this.dview,
  });

  // from json
  factory Deal.fromJson(Map<String, dynamic> json) {
    return Deal(
      id: json['deal_id'],
      parentId: json['parent_id'],
      title: json['title'],
      content: json['content'],
      photoId: json['photoId'],
      price: json['price'],
      createTime: DateTime.parse(json['createTime']),
      dheart: json['dheart'],
      dview: json['dview'],
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'deal_id': id,
      'parent_id': parentId,
      'title': title,
      'content': content,
      'photoId': photoId,
      'price': price,
      'createTime': createTime.toIso8601String(),
      'dheart': dheart,
      'dview': dview,
    };
  }
}
