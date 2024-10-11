import 'package:babystory/apis/raws_api.dart';
import 'package:babystory/models/parent.dart';
import 'package:babystory/providers/parent.dart';
import 'package:babystory/screens/comment.dart';
import 'package:babystory/screens/post_profile.dart';
import 'package:babystory/utils/date.dart';
import 'package:babystory/utils/http.dart';
import 'package:babystory/widgets/button/focusable_icon_button.dart';
import 'package:babystory/widgets/parent_post_list.dart';
import 'package:babystory/widgets/title/desc_title.dart';
import 'package:babystory/widgets/utils/divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostScreen extends StatefulWidget {
  final int id;
  const PostScreen({super.key, required this.id});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final HttpUtils httpUtils = HttpUtils();
  late Parent parent;
  late Future<Map<String, dynamic>> fetchDataFuture;
  int? pHeart;
  int? pComment;
  int? pScript;

  @override
  void initState() {
    super.initState();
    // Initialize parent and fetchDataFuture directly in initState
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
          url: '/post/${widget.id}',
          headers: {'Authorization': 'Bearer ${parent.jwt}'});
      return json ?? {};
    } catch (e) {
      debugPrint(e.toString());
      return {}; // Return an empty map to prevent errors
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
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return Stack(children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Image.network(
                          RawsApi.getPostLink(data['photoId']),
                          width: double.infinity,
                          height: 520,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          width: double.infinity,
                          height: 520,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.1),
                                Colors.black.withOpacity(0.8),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 32,
                          left: 20,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 44,
                              height: 46,
                              padding: const EdgeInsets.only(right: 2),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.black,
                                size: 26,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 122,
                          left: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['title'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                data['hashList'] != null
                                    ? data['hashList']
                                        .split(',')
                                        .map((word) => '#$word')
                                        .join(' ')
                                    : data['creater']['descript'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 72,
                          left: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PostProfileScreen(
                                                  parentId: data['creater']
                                                      ['parentId'])));
                                },
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundImage: NetworkImage(
                                      RawsApi.getProfileLink(parent.photoId)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${data['creater']['nickname']} · 조회수 ${data['pView']} · ${timeAgoString(data['createTime'])}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(45),
                                topRight: Radius.circular(45),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    // Replace ListView with Column
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _parseContent(data['content']),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                        decoration: BoxDecoration(
                            border: Border(
                          top: BorderSide(
                            color: Colors.grey.withOpacity(0.3),
                            width: 2,
                          ),
                        )),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PostProfileScreen(
                                                    parentId: data['creater']
                                                        ['parentId'])));
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CircleAvatar(
                                        radius: 22,
                                        backgroundImage: NetworkImage(
                                          RawsApi.getProfileLink(
                                              data['creater']['photoId']),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(data['creater']['nickname'],
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              )),
                                          const SizedBox(height: 3),
                                          Text(
                                              '친구 ${data['creater']['status']['friendCount']} · 이야기 ${data['creater']['status']['myStoryCount']}',
                                              style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                data['creater']['description'],
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black.withOpacity(0.7),
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FocusableIconButton(
                                    icon: Icons.notifications_none_outlined,
                                    label: '알림',
                                    color: const Color(0xff608CFF),
                                    onPressed: (isFocused) {
                                      // TODO: Implement notification feature
                                    },
                                  ),
                                  const SizedBox(width: 16),
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
                              const SizedBox(height: 20),
                            ],
                          ),
                        )),
                    const SizedBox(height: 12),
                    const UtilDivider(),
                    const DescTitle(
                        title: "쓴이의 다른 이야기",
                        desc: "쓴이가 작성한 다른 이야기도 들어보아요.",
                        setBorderBottom: true),
                    ParentPostList(
                        parentId: data['creater']['parentId'], limit: 5),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: HeartCommentScriptWidget(
                    postId: widget.id,
                    pHeart: data['pHeart'] ?? 0,
                    pComment: data['pComment'] ?? 0,
                    pScript: data['pScript'] ?? 0,
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

  List<Widget> _parseContent(String content) {
    final regex = RegExp(r'!\[\[(.*?)\]\]|([^!\[\]\n]+)');
    final matches = regex.allMatches(content);
    List<Widget> widgets = [];

    for (final match in matches) {
      if (match.group(1) != null) {
        // Image match
        final imageUrl = match.group(1)!.trim();
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(RawsApi.getPostLink(imageUrl),
                  width: double.infinity, height: 200, fit: BoxFit.cover),
            ),
          ),
        );
      } else if (match.group(2) != null) {
        // Text match
        final text = match.group(2)!.trim();
        if (text.isNotEmpty) {
          widgets.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.8,
                ),
              ),
            ),
          );
        }
      }
    }

    return widgets;
  }
}

class HeartCommentScriptWidget extends StatelessWidget {
  final int postId;
  final int pHeart;
  final int pComment;
  final int pScript;

  const HeartCommentScriptWidget({
    Key? key,
    required this.postId,
    required this.pHeart,
    required this.pComment,
    required this.pScript,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                // TODO: Implement like feature
              },
              child: Row(children: [
                const Icon(Icons.favorite_outlined,
                    color: Colors.red, size: 20),
                const SizedBox(width: 4),
                Text(
                  pHeart.toString(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ]),
            ),
            const SizedBox(width: 6),
            const Text("|",
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CommentScreen(postId: postId)));
              },
              child: Row(children: [
                const Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  pComment.toString(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ]),
            ),
            IconButton(
                onPressed: () {
                  // TODO: Implement share feature
                },
                icon: const Icon(Icons.share, color: Colors.grey, size: 18)),
          ],
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                // TODO: Implement script feature
              },
              child: Row(children: [
                const Icon(
                  Icons.bookmark,
                  color: Colors.grey,
                ),
                const SizedBox(width: 2),
                Text(
                  pScript.toString(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ]),
            ),
          ],
        ),
      ],
    );
  }
}
