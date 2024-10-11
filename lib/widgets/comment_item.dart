import 'package:babystory/apis/raws_api.dart';
import 'package:babystory/utils/date.dart';
import 'package:babystory/widgets/border_circle_avatar.dart';
import 'package:flutter/material.dart';

class CommentParentData {
  final String id;
  final String nickname;
  final String? photoId;

  CommentParentData({
    required this.id,
    required this.nickname,
    this.photoId,
  });

  CommentParentData.fromJson(Map<String, dynamic> json)
      : id = json['parent_id'],
        nickname = json['nickname'],
        photoId = json['photoId'];

  // print
  @override
  String toString() {
    return 'CommentParentData{id: $id, nickname: $nickname, photoId: $photoId}';
  }
}

class CommentData {
  final int id;
  final String content;
  final DateTime createdTime;
  final DateTime? modifyTime;
  final int cheart;
  final List<CommentData>? replies;
  final CommentParentData parent;

  CommentData(
      {required this.id,
      required this.content,
      required this.createdTime,
      this.modifyTime,
      required this.cheart,
      this.replies,
      required this.parent});

  CommentData.fromJson(Map<String, dynamic> json)
      : id = json['comment_id'],
        content = json['content'],
        createdTime = DateTime.parse(json['createTime']),
        modifyTime = json['modifyTime'] != null
            ? DateTime.parse(json['modifyTime'])
            : null,
        cheart = json['cheart'] ?? 0,
        replies = json['replies'] != null
            ? (json['replies'] as List)
                .map((e) => CommentData.fromJson(e))
                .toList()
            : null,
        parent = CommentParentData.fromJson(json['parent']);

  // print
  @override
  String toString() {
    return 'CommentData{id: $id, content: $content, createdTime: $createdTime, modifyTime: $modifyTime, cheart: $cheart, replies: $replies, parent: ${parent.toString()}}';
  }
}

class CommentItem extends StatelessWidget {
  final CommentData data;
  final bool showReplies;
  final bool showAddMoreCommentButton;
  final Function? onAddMoreComment;
  final IconData menuIcon;
  final Function? onMorePressed;

  const CommentItem(
      {Key? key,
      required this.data,
      this.showReplies = true,
      this.showAddMoreCommentButton = true,
      this.onAddMoreComment,
      this.menuIcon = Icons.more_vert,
      this.onMorePressed})
      : super(key: key);

  void addMoreComment() {
    if (onAddMoreComment != null) {
      onAddMoreComment!(data);
    }
  }

  void onPressMenu() {
    if (onMorePressed != null) {
      onMorePressed!(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BorderCircleAvatar(
                    radius: 12,
                    borderWidth: 0.5,
                    borderColor: Colors.black54,
                    image: data.parent.photoId != null
                        ? NetworkImage(
                                RawsApi.getProfileLink(data.parent.photoId))
                            as ImageProvider<Object>
                        : const AssetImage(
                            'assets/images/default_profile_image.jpeg')),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(data.parent.nickname,
                        style:
                            const TextStyle(fontSize: 11, color: Colors.black)),
                    Text(
                        data.modifyTime != null
                            ? formatDateTime(data.modifyTime!)
                            : formatDateTime(data.createdTime),
                        style: const TextStyle(
                            fontSize: 9, color: Colors.black54)),
                    const SizedBox(height: 2)
                  ],
                ),
              ],
            ),
            IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  menuIcon,
                  color: Colors.grey,
                  size: 18,
                ),
                onPressed: () => onPressMenu()),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 34),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  data.content,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
                if (showAddMoreCommentButton)
                  Column(
                    children: [
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => addMoreComment(),
                        child: const Text('답글달기',
                            style: TextStyle(
                                fontSize: 9,
                                color: Colors.black45,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
        if (showReplies && data.replies != null && data.replies!.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 36),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: data.replies!
                      .map((e) => CommentItem(
                          data: e,
                          showReplies: false,
                          showAddMoreCommentButton: false))
                      .toList(),
                ),
              )
            ],
          ),
        const SizedBox(height: 8),
        if (showReplies) const Divider(color: Colors.black12, height: 0.1),
      ]),
    );
  }
}
