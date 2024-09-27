import 'package:babystory/apis/raws_api.dart';
import 'package:flutter/material.dart';

class ProfileCardData {
  final String parentId;
  final String? photoId;
  final String name;
  final String info;
  final String desc;

  ProfileCardData({
    required this.parentId,
    this.photoId,
    required this.name,
    this.info = "",
    required this.desc,
  });

  factory ProfileCardData.fromJson(Map<String, dynamic> json) {
    return ProfileCardData(
      parentId: json['parent_id'],
      photoId: json['photoId'],
      name: json['name'],
      info: json['mainAddr'] ?? "대한민국",
      desc: json['desc'],
    );
  }

  void printData() {
    print(
        "ParentId: $parentId, PhotoId: $photoId, Name: $name, Info: $info, Desc: $desc");
  }
}

class ProfileCard extends StatelessWidget {
  final ProfileCardData parent;

  const ProfileCard({super.key, required this.parent});

  @override
  Widget build(BuildContext context) {
    parent.printData();
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 1,
            color: Colors.black12,
          )),
      width: 124,
      height: 172,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage:
                  NetworkImage(RawsApi.getProfileLink(parent.photoId)),
            ),
            const SizedBox(height: 14),
            Text(
              parent.name,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(parent.info,
                style: const TextStyle(fontSize: 11, color: Colors.black45)),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(parent.desc,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 11, color: Colors.black87)),
            ),
          ]),
    );
  }
}
