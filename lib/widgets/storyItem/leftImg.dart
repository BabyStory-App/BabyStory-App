import 'dart:math';

import 'package:babystory/utils/date.dart';
import 'package:flutter/material.dart';

class StoryItemLeftImg extends StatelessWidget {
  final String title;
  final String? description;
  final String? img;
  final int? heart;
  final int? comment;
  final DateTime date;

  const StoryItemLeftImg(
      {super.key,
      required this.title,
      this.description,
      this.img,
      this.heart = 0,
      this.comment = 0,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(height: 4),
            Text(
              description ?? "",
              style:
                  TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.6)),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border,
                      size: 12, color: Colors.redAccent),
                  const SizedBox(width: 3),
                  Text(heart.toString(),
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.redAccent)),
                  const SizedBox(width: 6),
                  const Padding(
                    padding: EdgeInsets.only(top: 1),
                    child: Icon(Icons.mode_comment_outlined,
                        size: 12, color: Colors.blue),
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Text(comment.toString(),
                        style: const TextStyle(
                            fontSize: 11,
                            color: Colors.blue,
                            fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(width: 4),
                  const Text("|",
                      style: TextStyle(
                          color: Colors.black45, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(timeAgo(date),
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.black.withOpacity(0.6))),
                  ),
                ],
              ),
            )
          ],
        )),
        if (Random().nextBool() && img != null)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                img!,
                width: 72,
                height: 72,
                fit: BoxFit.cover,
              ),
            ),
          ),
      ],
    );
  }
}
