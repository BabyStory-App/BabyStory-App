import 'package:babystory/models/parent.dart';
import 'package:babystory/providers/parent.dart';
import 'package:babystory/screens/create_post.dart';
import 'package:babystory/screens/post_search.dart';
import 'package:babystory/utils/http.dart';
import 'package:babystory/widgets/button/center_rounded_button.dart';
import 'package:babystory/widgets/postmain/banner.dart';
import 'package:babystory/widgets/postmain/neighbor_list.dart';
import 'package:babystory/widgets/postmain/postList.dart';
import 'package:babystory/widgets/postmain/row_posts_view.dart';
import 'package:babystory/widgets/title/desc_title.dart';
import 'package:babystory/widgets/utils/divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostMainScreen extends StatefulWidget {
  const PostMainScreen({super.key});

  @override
  State<PostMainScreen> createState() => _PostMainScreenState();
}

class _PostMainScreenState extends State<PostMainScreen> {
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
      var json = await httpUtils.get(
          url: '/main/create',
          headers: {'Authorization': 'Bearer ${parent.jwt}'});
      return json ?? {};
    } catch (e) {
      debugPrint(e.toString());
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return Stack(children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    PostMainBanner(parent: parent, data: data['banner']),
                    DescTitle(
                      title: "짝꿍 이야기",
                      desc: "짝꿍의 소소한 일상을 들어보아요.",
                      linkTitle: "모두 보기",
                      onLinkTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PostSearchScreen(
                                    moreMethod: 'friend')));
                      },
                      setBorderBottom: false,
                    ),
                    PostRowPostsView(data: data['friend']),
                    const UtilDivider(paddingTop: 12),
                    const DescTitle(
                        title: "친구 이야기",
                        desc: "친구들의 이야기를 들어보아요",
                        setBorderBottom: true),
                    PostmainPostList(data: data['friend_read']),
                    CenterRoundedButton(
                        areaHeight: 42,
                        text: "친구 이야기 더 보기",
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const PostSearchScreen(
                                      moreMethod: 'friend_read')));
                        }),
                    const UtilDivider(paddingTop: 12),
                    const DescTitle(
                        title: "이웃 사람, 정든 사람", desc: "새로운 이웃은 언제나 환영이죠!"),
                    PostmainNeighborList(data: data['neighbor']),
                    const UtilDivider(paddingTop: 12),
                    const DescTitle(title: "이웃 이야기", desc: "이웃의 이야기를 들어보아요."),
                    PostmainPostList(data: data['neighbor_post']),
                    CenterRoundedButton(
                        areaHeight: 42,
                        text: "이웃 이야기 더 보기",
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const PostSearchScreen(
                                      moreMethod: 'neighbor')));
                        }),
                    const UtilDivider(paddingTop: 12),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Positioned(
                bottom: 33,
                right: 25,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreatePostScreen()));
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              ),
            ]);
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }
}
