class Diary {
  final int id;
  final String parentId;
  final String babyId;
  final bool born;
  final String title;
  final DateTime createTime;
  final DateTime? modifyTime;
  String? photoId;

  Diary(
      {required this.id,
      required this.parentId,
      required this.babyId,
      required this.born,
      required this.title,
      required this.createTime,
      this.modifyTime,
      this.photoId});

  factory Diary.fromJson(Map<String, dynamic> json) {
    return Diary(
        id: json['diary_id'],
        parentId: json['parent_id'],
        babyId: json['baby_id'],
        born: json['born'] == 1,
        title: json['title'],
        createTime: DateTime.parse(json['createTime']),
        modifyTime: json['modifyTime'] != null
            ? DateTime.parse(json['modifyTime'])
            : null,
        photoId: json['cover']);
  }

  void printInfo() {
    print(
        "Diary(\n\tid: $id,\n\tparentId: $parentId,\n\tbabyId: $babyId,\n\tborn: $born,\n\ttitle: $title,\n\tcreateTime: $createTime,\n\tmodifyTime: $modifyTime,\n\tphotoId: $photoId\n)");
  }
}
