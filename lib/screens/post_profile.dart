import 'package:babystory/apis/friend_active.dart';
import 'package:babystory/apis/raws_api.dart';
import 'package:babystory/models/parent.dart';
import 'package:babystory/providers/parent.dart';
import 'package:babystory/screens/post.dart';
import 'package:babystory/utils/alert.dart';
import 'package:babystory/utils/http.dart';
import 'package:babystory/widgets/appbar/simple_closed_appbar.dart';
import 'package:babystory/widgets/button/focusable_icon_button.dart';
import 'package:babystory/widgets/setting_profile_overview_status.dart';
import 'package:babystory/widgets/storyItem/leftImg.dart';
import 'package:babystory/widgets/title/desc_title.dart';
import 'package:babystory/widgets/utils/divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostProfileParent {
  final String parentId;
  final String? photoId;
  final String parentName;
  final String? parentDesc;
  final int mateCount;
  final int friendCount;
  final int myStoryCount;

  PostProfileParent({
    required this.parentId,
    this.photoId,
    required this.parentName,
    required this.parentDesc,
    this.mateCount = 0,
    this.friendCount = 0,
    this.myStoryCount = 0,
  });
}

class PostProfileScreen extends StatefulWidget {
  final String parentId;

  const PostProfileScreen({Key? key, required this.parentId}) : super(key: key);

  @override
  State<PostProfileScreen> createState() => _PostProfileScreenState();
}

class _PostProfileScreenState extends State<PostProfileScreen> {
  final HttpUtils httpUtils = HttpUtils();
  late Parent me;
  late Future<bool> fetchDataFuture;
  late List<StoryItemLeftImgData> posts = [];
  late PostProfileParent parent;
  late FriendActive friendActiveApi;
  bool hasAlert = false;
  bool isFriend = false;

  @override
  void initState() {
    super.initState();
    me = getParentFromProvider();
    fetchDataFuture = fetchData();
  }

  Parent getParentFromProvider() {
    final me = context.read<ParentProvider>().parent;
    if (me == null) {
      throw Exception('Parent is null');
    }
    return me;
  }

  void alertAndPop() {
    Alert.alert(
        context: context, title: "문제가 발생했습니다.", content: "잠시후에 다시 시도해주세요.");
    Navigator.pop(context);
  }

  Future<bool> fetchData() async {
    try {
      var res = await httpUtils.get(
          url: '/post/poster/profile/${widget.parentId}',
          headers: {'Authorization': 'Bearer ${me.jwt ?? ''}'});

      if (res == null) {
        alertAndPop();
        return false;
      }
      if (res['parent'] == null || res['posts'] == null) {
        alertAndPop();
        return false;
      }

      parent = PostProfileParent(
        parentId: res['parent']['parentId'],
        photoId: res['parent']['photoId'],
        parentName: res['parent']['parentName'],
        parentDesc: res['parent']['parentDesc'],
        mateCount: res['parent']['mateCount'],
        friendCount: res['parent']['friendCount'],
        myStoryCount: res['parent']['myStoryCount'],
      );

      posts = (res['posts'] as List)
          .map((e) => StoryItemLeftImgData.fromJson(e))
          .toList();

      friendActiveApi = FriendActive(jwt: me.jwt!, friendUid: parent.parentId);
      var value = await friendActiveApi.getAlertAndFriendStatus();
      setState(() {
        hasAlert = value[0];
        isFriend = value[1];
      });

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  void toggleFriendActiveState(String type) {
    if (type == 'alert') {
      friendActiveApi.toggleAlert();
      setState(() {
        hasAlert = !hasAlert;
      });
    } else if (type == 'friend') {
      friendActiveApi.toggleFriend();
      setState(() {
        isFriend = !isFriend;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleClosedAppBar(
        title: "프로필",
        icon: Icons.arrow_back_ios_new,
      ),
      body: FutureBuilder<bool>(
        future: fetchDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data! == true) {
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
                        parent.parentName,
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
                            RawsApi.getProfileLink(parent.photoId),
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
                            count: parent.mateCount,
                          ),
                          const SizedBox(width: 20),
                          SettingProfileOverviewStatus(
                            name: "친구들",
                            count: parent.friendCount,
                          ),
                          const SizedBox(width: 20),
                          SettingProfileOverviewStatus(
                            name: "이야기",
                            count: parent.myStoryCount,
                          ),
                        ],
                      ),
                      me.uid == parent.parentId
                          ? const SizedBox(width: 60)
                          : Row(
                              children: [
                                FocusableIconButton(
                                  icon: Icons.notifications_none_outlined,
                                  label: '알림',
                                  initFocusState: hasAlert,
                                  color: const Color(0xff608CFF),
                                  onPressed: (isFocused) {
                                    toggleFriendActiveState('alert');
                                  },
                                ),
                                const SizedBox(width: 12),
                                FocusableIconButton(
                                  icon: Icons.add,
                                  label: '친구',
                                  color: const Color(0xff608CFF),
                                  initFocusState: isFriend,
                                  onPressed: (isFocused) {
                                    toggleFriendActiveState('friend');
                                  },
                                  focusIcon: Icons.check,
                                ),
                              ],
                            ),
                    ],
                  ),
                ),

                // Profile Description
                if (parent.parentDesc != null) ...[
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    child: Text(
                      parent.parentDesc!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.8,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
                const UtilDivider(paddingTop: 20, paddingBottom: 8),

                DescTitle(
                    setBorderBottom: true,
                    title: "${parent.parentName}의 이야기",
                    desc: "${parent.parentName}의 이야기를 들어보아요."),
                const SizedBox(height: 12),
                // Posts List
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostScreen(
                              id: posts[index].id!,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: StoryItemLeftImg(
                          title: posts[index].title,
                          description: posts[index].description,
                          img: posts[index].img,
                          heart: posts[index].heart,
                          comment: posts[index].comment,
                          info: posts[index].info,
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
