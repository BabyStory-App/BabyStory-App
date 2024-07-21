class Purchase {
  final int id;
  final String parentId;
  final String title;
  String? content;
  final String photoId;
  final DateTime createTime;
  final String link; // 공동 구매 사이트 링크
  final int jheart;
  final int jview;
  final int joint;

  Purchase({
    required this.id,
    required this.parentId,
    required this.title,
    this.content,
    required this.photoId,
    required this.createTime,
    required this.link,
    required this.jheart,
    required this.jview,
    required this.joint,
  });

  // from json
  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
      id: json['purchase_id'],
      parentId: json['parent_id'],
      title: json['title'],
      content: json['content'],
      photoId: json['photoId'],
      createTime: DateTime.parse(json['createTime']),
      link: json['link'],
      jheart: json['jheart'],
      jview: json['jview'],
      joint: json['joint'],
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'purchase_id': id,
      'parent_id': parentId,
      'title': title,
      'content': content,
      'photoId': photoId,
      'createTime': createTime.toIso8601String(),
      'link': link,
      'jheart': jheart,
      'jview': jview,
      'joint': joint,
    };
  }
}
