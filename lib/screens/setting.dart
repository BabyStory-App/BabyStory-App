import 'package:babystory/enum/gender.dart';
import 'package:babystory/models/baby.dart';
import 'package:babystory/models/parent.dart';
import 'package:babystory/providers/parent.dart';
import 'package:babystory/screens/edit_baby_profile.dart';
import 'package:babystory/screens/setting_friends.dart';
import 'package:babystory/screens/story_list.dart';
import 'package:babystory/services/auth.dart';
import 'package:babystory/utils/http.dart';
import 'package:babystory/widgets/baby_card.dart';
import 'package:babystory/widgets/iconRowItem.dart';
import 'package:babystory/widgets/session_title1.dart';
import 'package:babystory/widgets/setting_profile_overview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

// https://raisingchildren.net.au/__data/assets/image/0023/47741/baby-behaviour-and-awarenessnarrow.jpg
class _SettingState extends State<Setting> {
  final HttpUtils httpUtils = HttpUtils();
  final AuthServices _authServices = AuthServices();
  List<Baby> babies = [];

  void createNewBaby() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const EditBabyProfile()));
  }

  Parent getParentFromProvider() {
    final parent = context.read<ParentProvider>().parent;
    if (parent == null) {
      throw Exception('Parent is null');
    }
    return parent;
  }

  @override
  void initState() {
    super.initState();
    _fetchBabies();
  }

  Future<void> _fetchBabies() async {
    try {
      final parent = getParentFromProvider();
      var json = await httpUtils.get(
          url: '/baby', headers: {'Authorization': 'Bearer ${parent.jwt}'});
      if (json == null) {
        return;
      }
      var res = json['baby'] ?? [];
      babies =
          res.map<Baby>((baby) => Baby.fromJson(baby)).toList().cast<Baby>();
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
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
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditBabyProfile(
                                                    baby: babies[index])));
                                  },
                                  child: BabyCard(baby: babies[index])),
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
