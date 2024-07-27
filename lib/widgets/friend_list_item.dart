import 'package:babystory/models/parent.dart';
import 'package:flutter/material.dart';

class FriendListItem extends StatelessWidget {
  final Parent parent;
  final bool displayAddButton;
  final bool isMate;

  const FriendListItem(
      {super.key,
      required this.parent,
      this.displayAddButton = false,
      this.isMate = false});

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
                backgroundImage: NetworkImage(
                    "https://raisingchildren.net.au/__data/assets/image/${parent.photoId}"),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    parent.nickname,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  if (parent.description != null) const SizedBox(height: 2),
                  if (parent.description != null)
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        parent.description!,
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
              if (displayAddButton)
                OutlinedButton(
                  onPressed: () {
                    print("On Click");
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(width: 0.7, color: Colors.blue),
                    backgroundColor: isMate ? Colors.blue : Colors.white,
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.only(
                        left: 4, right: 8, top: 3, bottom: 3),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(isMate ? Icons.check_rounded : Icons.add,
                          size: 18, color: isMate ? Colors.white : Colors.blue),
                      const SizedBox(width: 2),
                      Text(
                        "친구",
                        style: TextStyle(
                          color: isMate ? Colors.white : Colors.blue,
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
