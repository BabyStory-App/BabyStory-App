import 'package:babystory/apis/raws_api.dart';
import 'package:babystory/utils/date.dart';
import 'package:flutter/material.dart';

class StoryItemLeftImgData {
  final int? id;
  final String title;
  final String? description;
  final String? img;
  final int? heart;
  final int? comment;
  final String? info;

  StoryItemLeftImgData(
      {required this.title,
      this.id,
      this.description,
      this.img,
      this.heart = 0,
      this.comment = 0,
      this.info});

  factory StoryItemLeftImgData.fromJson(Map<String, dynamic> json) {
    return StoryItemLeftImgData(
      id: json['postid'],
      title: json['title'],
      description: json['desc'],
      img: json['photoId'],
      heart: json['pHeart'],
      comment: json['comment'],
      info: json['author_name'],
    );
  }
}

class StoryItemLeftImg extends StatelessWidget {
  final String title;
  final String? description;
  final String? img;
  final int? heart;
  final int? comment;
  final String? info;

  const StoryItemLeftImg(
      {super.key,
      required this.title,
      this.description,
      this.img,
      this.heart = 0,
      this.comment = 0,
      this.info});

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
            if (description != null) const SizedBox(height: 4),
            if (description != null)
              Text(
                description!.replaceAll('\n', ''),
                style: const TextStyle(fontSize: 11, color: Colors.grey),
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
                  Text(heart == null ? "0" : heart.toString(),
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
                    child: Text(comment == null ? "0" : comment.toString(),
                        style: const TextStyle(
                            fontSize: 11,
                            color: Colors.blue,
                            fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(width: 4),
                  if (info != null)
                    const Text("|",
                        style: TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.bold)),
                  const SizedBox(width: 4),
                  if (info != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(info!,
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.black.withOpacity(0.6))),
                    ),
                ],
              ),
            )
          ],
        )),
        if (img != null)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey.withOpacity(0.6),
                    width: 0.5), // 원하는 색상과 두께로 설정
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  RawsApi.getPostLink(img),
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
