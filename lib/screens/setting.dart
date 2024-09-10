import 'package:babystory/enum/gender.dart';
import 'package:babystory/models/baby.dart';
import 'package:babystory/screens/setting_friends.dart';
import 'package:babystory/screens/story_list.dart';
import 'package:babystory/services/auth.dart';
import 'package:babystory/widgets/baby_card.dart';
import 'package:babystory/widgets/iconRowItem.dart';
import 'package:babystory/widgets/session_title1.dart';
import 'package:babystory/widgets/setting_profile_overview.dart';
import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

// https://raisingchildren.net.au/__data/assets/image/0023/47741/baby-behaviour-and-awarenessnarrow.jpg
class _SettingState extends State<Setting> {
  final AuthServices _authServices = AuthServices();
  List<Baby> babies = [
    Baby(
        id: "asdafasdas-dasd-awdasd-asda",
        obn: "obn1",
        name: "정새봄",
        gender: Gender.male,
        birthDate: DateTime.parse("20240102"),
        bloodType: "AB+",
        description: '무럭 무럭 자라는 우리 첫째 아이. 항상 블록을 가지고 정겹게 놀고 있는 아이.',
        photoId: "0023/47741/baby-behaviour-and-awarenessnarrow.jpg"),
    Baby(
        id: "asdafasdas-dasd-awdaagfafgsd-asda",
        obn: "obn1",
        name: "정다운",
        gender: Gender.male,
        birthDate: DateTime.parse("20231031"),
        bloodType: "B+",
        description: '사랑과 기쁨과 행복을 주는 하나 밖에 없는 우리 둘째 아이. 항상 웃음이 끊이질 않아요.',
        photoId: "0023/47741/baby-behaviour-and-awarenessnarrow.jpg"),
    Baby(
        id: "asdafagagasdas-dasd-awdasd-asda",
        obn: "obn1",
        name: "정단테",
        gender: Gender.male,
        birthDate: DateTime.parse("20230501"),
        bloodType: "AB+",
        description: '서울 중앙에 있는 펜트하우스 최상층에서 살고 있는 우리 막내 아이. 항상 높은 곳을 향해.',
        photoId: "0023/47741/baby-behaviour-and-awarenessnarrow.jpg"),
  ];

  void createNewBaby() {
    print("CreateNewBaby");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 32,
                ),
                const SettingProfileOverview(),
                const SizedBox(
                  height: 16,
                ),
                SessionTitle1(
                    title: "아기 정보",
                    buttonText: "아기 추가",
                    onPressed: createNewBaby),
                const SizedBox(height: 12),
                babies.isNotEmpty
                    ? SizedBox(
                        height: 172,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: babies.length,
                          itemBuilder: (BuildContext context, int index) =>
                              BabyCard(baby: babies[index]),
                          separatorBuilder: (BuildContext ctx, int idx) =>
                              const SizedBox(width: 20),
                        ),
                      )
                    : Container(
                        height: 172,
                        alignment: Alignment.center,
                        child: TextButton(
                            onPressed: createNewBaby,
                            child: const Text("아이를 추가해주세요.",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54))),
                      ),
                const SizedBox(height: 28),
                const SessionTitle1(title: "이야기"),
                const SizedBox(height: 10),
                IconRowItem(
                    icon: Icons.edit_document,
                    text: "나의 이야기",
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const StoryList(pageTitle: "나의 이야기")))),
                const SizedBox(height: 10),
                IconRowItem(
                    icon: Icons.bookmark,
                    text: "내가 저장한 이야기",
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const StoryList(pageTitle: "내가 저장한 이야기")))),
                const SizedBox(height: 10),
                IconRowItem(
                    icon: Icons.history,
                    text: "내가 읽은 이야기",
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const StoryList(pageTitle: "내가 읽은 이야기")))),
                const SizedBox(height: 10),
                IconRowItem(
                    icon: Icons.favorite,
                    text: "내가 좋아한 이야기",
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const StoryList(pageTitle: "내가 좋아한 이야기")))),
                const SizedBox(height: 28),
                const SessionTitle1(title: "짝꿍과 친구"),
                const SizedBox(height: 10),
                IconRowItem(
                    icon: Icons.people,
                    text: "나의 짝꿍",
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const SettingFriends(type: "myMates")))),
                const SizedBox(height: 10),
                IconRowItem(
                    icon: Icons.subscriptions_rounded,
                    text: "나의 친구들",
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const SettingFriends(type: "myFriends")))),
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _authServices.signOut();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(174, 204, 55, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      child: const Text(
                        '로그아웃',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
