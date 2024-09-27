import 'dart:math';

import 'package:babystory/apis/raws_api.dart';
import 'package:babystory/screens/post.dart';
import 'package:babystory/widgets/border_circle_avatar.dart';
import 'package:babystory/widgets/icons/circle_icon.dart';
import 'package:flutter/material.dart';

class RowPostsViewData {
  final int id;
  final String title;
  final String? photoId;
  final String authorName;
  final String? authorPhotoId;
  final bool hasHeart;

  RowPostsViewData({
    required this.id,
    required this.title,
    required this.photoId,
    required this.authorName,
    this.authorPhotoId,
    this.hasHeart = false,
  });

  factory RowPostsViewData.fromJson(Map<String, dynamic> json) {
    return RowPostsViewData(
      id: json['postid'],
      title: json['title'],
      photoId: json['photoId'],
      authorName: json['author_name'],
      authorPhotoId: json['author_photo'],
      hasHeart: json['hasHeart'] ?? false,
    );
  }

  void printData() {
    debugPrint(
        'id: $id, title: $title, photoId: $photoId, authorName: $authorName, authorPhotoId: $authorPhotoId');
  }
}

class RowPostsView extends StatelessWidget {
  final List<RowPostsViewData> posts;

  const RowPostsView({Key? key, required this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16),
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: posts.map((post) {
            return Container(
              margin: const EdgeInsets.only(right: 16), // 각 카드 간격 설정
              width: 128,
              height: 188,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), // 모서리 둥글게
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3), // 그림자 색상
                    blurRadius: 1, // 흐려짐 정도
                    offset: const Offset(2, 3), // 그림자 위치
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostScreen(id: post.id),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      Image.network(
                        RawsApi.getPostLink(post.photoId),
                        width: 128,
                        height: 188,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        width: 128,
                        height: 188,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          top: 8,
                          right: 8,
                          child: CircleIcon(
                              icon: Icons.favorite, hasChecked: post.hasHeart)),
                      Positioned(
                        bottom: 26,
                        left: 8,
                        child: SizedBox(
                          width: 112,
                          child: Text(
                            post.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        bottom: 6,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            BorderCircleAvatar(
                                radius: 7,
                                borderWidth: 0.5,
                                image: post.authorPhotoId != null
                                    ? NetworkImage(RawsApi.getProfileLink(
                                            post.authorPhotoId))
                                        as ImageProvider<Object>
                                    : const AssetImage(
                                        'assets/images/default_profile_image.jpeg')),
                            const SizedBox(width: 4),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Text(
                                post.authorName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
