import 'package:babystory/apis/raws_api.dart';
import 'package:babystory/models/parent.dart';
import 'package:babystory/providers/parent.dart';
import 'package:babystory/screens/edit_parent_profile.dart';
import 'package:babystory/utils/http.dart';
import 'package:babystory/widgets/setting_profile_overview_status.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';

class SettingProfileOverview extends StatefulWidget {
  const SettingProfileOverview({super.key});

  @override
  State<SettingProfileOverview> createState() => _SettingProfileOverviewState();
}

class _SettingProfileOverviewState extends State<SettingProfileOverview> {
  final HttpUtils httpUtils = HttpUtils();
  int mateCount = 0;
  int friendCount = 0;
  int myStoryCount = 0;

  Parent getParentFromProvider() {
    final parent = context.read<ParentProvider>().parent;
    if (parent == null) {
      throw Exception('Parent is null');
    }
    return parent;
  }

  Parent watchParentFromProvider() {
    final parent = context.watch<ParentProvider>().parent;
    if (parent == null) {
      throw Exception('Parent is null');
    }
    return parent;
  }

  Future<Map<String, int?>> getParentOverview() async {
    final parent = getParentFromProvider();
    var json = await httpUtils.get(
        url: '/setting/overview',
        headers: {'Authorization': 'Bearer ${parent.jwt}'});
    if (json == null) {
      return {
        "mateCount": 0,
        "friendCount": 0,
        "myStoryCount": 0,
      };
    }
    return {
      "mateCount": json['data']['mateCount'],
      "friendCount": json['data']['friendCount'],
      "myStoryCount": json['data']['myStoryCount']
    };
  }

  @override
  void initState() {
    super.initState();
    getParentOverview().then((value) {
      setState(() {
        mateCount = value["mateCount"] ?? 0;
        friendCount = value["friendCount"] ?? 0;
        myStoryCount = value["myStoryCount"] ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final parent = watchParentFromProvider();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                parent.printInfo();
              },
              child: Text(parent.nickname,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87)),
            ),
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey, // 이미지 로드 실패 시 사용할 기본 배경색
              child: ClipOval(
                child: Image.network(
                  RawsApi.getProfileLink(parent.photoId),
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
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SettingProfileOverviewStatus(name: "짝꿍", count: mateCount),
                const SizedBox(width: 20),
                SettingProfileOverviewStatus(name: "친구들", count: friendCount),
                const SizedBox(width: 20),
                SettingProfileOverviewStatus(name: "이야기", count: myStoryCount),
              ],
            ),
            Row(
              children: [
                OutlinedButton(
                    onPressed: () {
                      Share.share(parent?.description ?? parent?.email ?? "");
                    },
                    style: OutlinedButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6)),
                    child: const Text(
                      "프로필 공유",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    )),
                const SizedBox(
                  width: 8,
                ),
                OutlinedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditParentProfile())),
                    style: OutlinedButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6)),
                    child: const Text(
                      "프로필 편집",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    )),
              ],
            )
          ],
        )
      ],
    );
  }
}
