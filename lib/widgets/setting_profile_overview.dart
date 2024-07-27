import 'package:babystory/widgets/setting_profile_overview_status.dart';
import 'package:flutter/material.dart';

class SettingProfileOverview extends StatelessWidget {
  const SettingProfileOverview({super.key});

  void shareProfile() {
    print("Share Profile");
  }

  void editProfile() {
    print("Edit Profile");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("아크하드",
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87)),
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
                const SizedBox(width: 20),
                SettingProfileOverviewStatus(name: "친구들", count: 58),
                const SizedBox(width: 20),
                SettingProfileOverviewStatus(name: "이야기", count: 23),
              ],
            ),
            Row(
              children: [
                OutlinedButton(
                    onPressed: shareProfile,
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
                    onPressed: editProfile,
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
