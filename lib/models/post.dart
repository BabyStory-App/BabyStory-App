enum PostReveal { closed, mate, friend, all }

List<String> PostRevealList = PostReveal.values.map((e) => e.name).toList();

PostReveal matchPostReveal(int revealNum) {
  switch (revealNum) {
    case 0:
      return PostReveal.closed;
    case 1:
      return PostReveal.mate;
    case 2:
      return PostReveal.friend;
    case 3:
      return PostReveal.all;
  }
  return PostReveal.closed;
}

class Post {
  final int id;
  final String parentId;
  PostReveal reveal; // 0: closed, 1: mate, 2: friend, 3: all
  final String title;
  final DateTime createTime;
  DateTime? modifyTime;
  DateTime? deleteTime;
  int? pHeart; // 좋아요 수
  int? pScript; // 스크랩 수
  int? pView; // 조회수
  int? pComment; // 댓글 수
  String? hashList; // 해시태그 리스트(EX: 해시태그1,해시태그2,...)

  Post({
    required this.id,
    required this.parentId,
    this.reveal = PostReveal.closed,
    required this.title,
    required this.createTime,
    this.modifyTime,
    this.deleteTime,
    this.pHeart,
    this.pScript,
    this.pView,
    this.pComment,
    this.hashList,
  });

  // from json
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['post_id'],
      parentId: json['parent_id'],
      reveal: matchPostReveal(json['reveal']),
      title: json['title'],
      createTime: DateTime.parse(json['createTime']),
      modifyTime: json['modifyTime'] != null
          ? DateTime.parse(json['modifyTime'])
          : null,
      deleteTime: json['deleteTime'] != null
          ? DateTime.parse(json['deleteTime'])
          : null,
      pHeart: json['pHeart'],
      pScript: json['pScript'],
      pView: json['pView'],
      pComment: json['pComment'],
      hashList: json['hashList'],
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'post_id': id,
      'parent_id': parentId,
      'reveal': reveal.index,
      'title': title,
      'createTime': createTime.toIso8601String(),
      'modifyTime': modifyTime?.toIso8601String(),
      'deleteTime': deleteTime?.toIso8601String(),
      'pHeart': pHeart,
      'pScript': pScript,
      'pView': pView,
      'pComment': pComment,
      'hashList': hashList,
    };
  }
}
