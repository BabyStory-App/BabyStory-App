import 'package:babystory/providers/parent.dart';
import 'package:babystory/screens/edit_parent_profile.dart';
import 'package:babystory/widgets/setting_profile_overview_status.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';

class SettingProfileOverview extends StatelessWidget {
  const SettingProfileOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final parent = context.watch<ParentProvider>().parent;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                parent?.printInfo();
              },
              child: Text("아크하드",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87)),
            ),
            CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(
                  "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg"),
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
            const Row(
              children: [
                SettingProfileOverviewStatus(name: "짝꿍", count: 23),
                SizedBox(width: 20),
                SettingProfileOverviewStatus(name: "친구들", count: 58),
                SizedBox(width: 20),
                SettingProfileOverviewStatus(name: "이야기", count: 23),
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
