import 'package:babystory/apis/raws_api.dart';
import 'package:babystory/models/parent.dart';
import 'package:babystory/providers/parent.dart';
import 'package:babystory/screens/post.dart';
import 'package:babystory/utils/http.dart';
import 'package:babystory/widgets/appbar/simple_closed_appbar.dart';
import 'package:babystory/widgets/button/focusable_icon_button.dart';
import 'package:babystory/widgets/setting_profile_overview_status.dart';
import 'package:babystory/widgets/storyItem/leftImg.dart';
import 'package:babystory/widgets/title/desc_title.dart';
import 'package:babystory/widgets/utils/divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostProfileScreen extends StatefulWidget {
  final String parentId;

  const PostProfileScreen({Key? key, required this.parentId}) : super(key: key);

  @override
  State<PostProfileScreen> createState() => _PostProfileScreenState();
}

class _PostProfileScreenState extends State<PostProfileScreen> {
  final HttpUtils httpUtils = HttpUtils();
  late Parent parent;
  late Future<Map<String, dynamic>> fetchDataFuture;

  @override
  void initState() {
    super.initState();
    parent = getParentFromProvider();
    fetchDataFuture = fetchData();
  }

  Parent getParentFromProvider() {
    final parent = context.read<ParentProvider>().parent;
    if (parent == null) {
      throw Exception('Parent is null');
    }
    return parent;
  }

  Future<Map<String, dynamic>> fetchData() async {
    try {
      var json = await Future.delayed(const Duration(seconds: 1), () {
        return {
          'parent': {
            'parentId': 'P001',
            'parentName': '아크하드',
            "parentDesc":
                "밤에 먹는 맥주가 제일 맛있는데 살이 찐단 말이지... 그런데 치킨을 사왔는데 또 안먹을 수도 없고...",
            'photoId': 'P001',
            'mateCount': 1,
            'friendCount': 2,
            'myStoryCount': 3,
          },
          'posts': [
            {
              'postid': 4,
              'title': 'title',
              'photoId': '4-1',
              'author_name': 'author_name',
              'desc': 'desc',
              'pHeart': 5,
              'comment': 6,
            },
            {
              'postid': 4,
              'title': 'title',
              'photoId': '4-1',
              'author_name': 'author_name',
              'desc': 'desc',
              'pHeart': 5,
              'comment': 6,
            }
          ]
        };
      });
      return json;
    } catch (e) {
      debugPrint(e.toString());
      return {}; // 에러가 발생하면 빈 맵을 반환하여 오류를 방지합니다.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleClosedAppBar(
        title: "프로필",
        icon: Icons.arrow_back_ios_new,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            final posts = data['posts'] as List;
            return Column(
              children: [
                // Profile Header
                Padding(
                  padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        data['parent']['parentName'],
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey,
                        child: ClipOval(
                          child: Image.network(
                            RawsApi.getProfileLink(data['parent']['photoId']),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey,
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Profile Stats and Actions
                Padding(
                  padding:
                      const EdgeInsets.only(left: 24, right: 24, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          SettingProfileOverviewStatus(
                            name: "짝꿍",
                            count: data['parent']['mateCount'],
                          ),
                          const SizedBox(width: 20),
                          SettingProfileOverviewStatus(
                            name: "친구들",
                            count: data['parent']['friendCount'],
                          ),
                          const SizedBox(width: 20),
                          SettingProfileOverviewStatus(
                            name: "이야기",
                            count: data['parent']['myStoryCount'],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          FocusableIconButton(
                            icon: Icons.notifications_none_outlined,
                            label: '알림',
                            color: const Color(0xff608CFF),
                            onPressed: (isFocused) {
                              // TODO: Implement notification feature
                            },
                          ),
                          const SizedBox(width: 12),
                          FocusableIconButton(
                            icon: Icons.add,
                            label: '친구',
                            color: const Color(0xff608CFF),
                            onPressed: (isFocused) {
                              // TODO: Implement friend feature
                            },
                            focusIcon: Icons.check,
                            initFocusState: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Profile Description
                if (data['parent']['parentDesc'] != null) ...[
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    child: Text(
                      data['parent']['parentDesc'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.8,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
                const UtilDivider(paddingTop: 24, paddingBottom: 4),

                DescTitle(
                    setBorderBottom: true,
                    title: "${data['parent']['parentName'] ?? '작성자'}의 이야기",
                    desc:
                        "${data['parent']['parentName'] ?? '작성자'}의 이야기를 들어보아요."),
                const SizedBox(height: 8),
                // Posts List
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostScreen(
                              id: posts[index]['postid'],
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: StoryItemLeftImg(
                          title: posts[index]['title'],
                          description: posts[index]['desc'],
                          img: posts[index]['photoId'],
                          heart: posts[index]['pHeart'],
                          comment: posts[index]['comment'],
                          info: posts[index]['author_name'],
                        ),
                      ),
                    ),
                    separatorBuilder: (ctx, idx) => const SizedBox(height: 4),
                    itemCount: posts.length,
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }
}
