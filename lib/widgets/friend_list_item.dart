import 'package:babystory/apis/raws_api.dart';
import 'package:babystory/screens/setting_friends.dart';
import 'package:flutter/material.dart';

class FriendListItem extends StatefulWidget {
  final SettingFriendItem parent;
  final bool displayAddButton;
  bool isMate;

  FriendListItem(
      {super.key,
      required this.parent,
      this.displayAddButton = false,
      this.isMate = false});

  @override
  State<FriendListItem> createState() => _FriendListItemState();
}

class _FriendListItemState extends State<FriendListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey, // 이미지 로드 실패 시 사용할 기본 배경색
                child: ClipOval(
                  child: Image.network(
                    RawsApi.getProfileLink(widget.parent.photoId),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey, // 에러 시 회색으로 채우기
                        child: const Icon(Icons.person,
                            color: Colors.white), // 에러 시 기본 아이콘 표시 (선택 사항)
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.parent.nickname,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  if (widget.parent.description != null)
                    const SizedBox(height: 2),
                  if (widget.parent.description != null)
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        widget.parent.description!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 11, color: Colors.black54),
                      ),
                    ),
                ],
              )
            ],
          ),
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.black38),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.message_outlined,
                    size: 14,
                    color: Colors.black38,
                  ),
                  onPressed: () {
                    print('message');
                  },
                ),
              ),
              const SizedBox(width: 8),
              if (widget.displayAddButton)
                OutlinedButton(
                  onPressed: () {
                    print("On Click");
                    setState(() {
                      widget.isMate = !widget.isMate;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(width: 0.7, color: Colors.blue),
                    backgroundColor: widget.isMate ? Colors.blue : Colors.white,
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.only(
                        left: 4, right: 8, top: 3, bottom: 3),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(widget.isMate ? Icons.check_rounded : Icons.add,
                          size: 18,
                          color: widget.isMate ? Colors.white : Colors.blue),
                      const SizedBox(width: 2),
                      Text(
                        "친구",
                        style: TextStyle(
                          color: widget.isMate ? Colors.white : Colors.blue,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}
