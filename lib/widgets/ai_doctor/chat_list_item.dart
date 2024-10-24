import 'package:babystory/utils/date.dart';
import 'package:flutter/material.dart';

class ChatListItemData {
  final int id;
  final DateTime createTime;
  final String lastMessage;

  ChatListItemData({
    required this.id,
    required this.createTime,
    required this.lastMessage,
  });

  factory ChatListItemData.fromJson(Map<String, dynamic> json) {
    return ChatListItemData(
      id: json['id'],
      createTime: DateTime.parse(json['createTime']),
      lastMessage: json['lastChat']['res'],
    );
  }
}

class AiDoctorChatListItem extends StatelessWidget {
  final ChatListItemData chat;

  const AiDoctorChatListItem({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          // Expanded widget to allow the text to take up the remaining space
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Last message text with ellipsis if it overflows
                Text(
                  chat.lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  formatDateTimeBarKorean(chat.createTime),
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
}
