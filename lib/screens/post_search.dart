import 'package:babystory/models/parent.dart';
import 'package:babystory/providers/parent.dart';
import 'package:babystory/screens/post.dart';
import 'package:babystory/utils/http.dart';
import 'package:babystory/widgets/button/focusable_icon_button2.dart';
import 'package:babystory/widgets/storyItem/leftImg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostSearchScreen extends StatefulWidget {
  final String? searchWord;
  final String? moreMethod;

  const PostSearchScreen({Key? key, this.searchWord, this.moreMethod})
      : super(key: key);

  @override
  State<PostSearchScreen> createState() => _PostSearchState();
}

class _PostSearchState extends State<PostSearchScreen> {
  final HttpUtils httpUtils = HttpUtils();
  late Parent parent;
  List<StoryItemLeftImgData> posts = [];
  int page = 0;
  int size = 10;
  String? searchWord;
  String? moreMethod;

  bool isLoading = false;
  bool hasMore = true;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    parent = getParentFromProvider();
    searchWord = widget.searchWord;
    moreMethod = widget.moreMethod;

    if (searchWord != null) {
      _searchController.text = searchWord!;
    }
    fetchData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        // Near the bottom
        if (!isLoading && hasMore) {
          fetchData();
        }
      }
    });
  }

  Parent getParentFromProvider() {
    final parent = context.read<ParentProvider>().parent;
    if (parent == null) {
      throw Exception('Parent is null');
    }
    return parent;
  }

  Future<void> fetchData() async {
    if (isLoading || !hasMore) return;
    setState(() {
      isLoading = true;
    });
    try {
      Map<String, dynamic> body = {};
      if (moreMethod != null) {
        switch (moreMethod) {
          case 'friend':
            body['type'] = 'friend';
            break;
          case 'friend_read':
            body['type'] = 'friend_read';
            break;
          case 'neighbor':
            body['type'] = 'neighbor';
            break;
        }
      }
      if (!body.containsKey('type') && searchWord != null) {
        body['search'] = searchWord!;
      }
      if (body.isNotEmpty) {
        body['page'] = page;
        body['size'] = size;
        var json = await httpUtils.post(
            url: moreMethod != null
                ? '/post/search/recommend'
                : '/post/search/result',
            headers: {'Authorization': 'Bearer ${parent.jwt}'},
            body: body);

        List<StoryItemLeftImgData> newPosts =
            json == null || json['result'] == null
                ? []
                : (json['result'] as List)
                    .map((e) => StoryItemLeftImgData.fromJson(e))
                    .toList();

        setState(() {
          if (newPosts.isEmpty) {
            hasMore = false;
          } else {
            posts.addAll(newPosts);
            page += 1;
          }
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          hasMore = false;
        });
      }
      print('posts: $posts');
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  void refresh({String? search, String? more}) {
    print("$moreMethod -> $more");
    setState(() {
      page = 0;
      searchWord = search;
      _searchController.text = search ?? "";
      moreMethod = more;
      posts.clear();
      hasMore = true;
    });
    fetchData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  Expanded(
                    child: Container(
                      padding:
                          const EdgeInsets.only(left: 12, right: 8, top: 17),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 240, 240, 240),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      height: 36,
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: '검색어를 입력해주세요.',
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(fontSize: 14),
                        onSubmitted: (value) {
                          refresh(search: value);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FocusableIconButton2(
                      text: "짝꿍 이야기",
                      icon: Icons.people,
                      onClick: () => refresh(more: "friend"),
                      hasFocused: moreMethod == "friend",
                    ),
                    const SizedBox(width: 8),
                    FocusableIconButton2(
                      text: "친구 이야기",
                      icon: Icons.people,
                      onClick: () => refresh(more: "friend_read"),
                      hasFocused: moreMethod == "friend_read",
                    ),
                    const SizedBox(width: 8),
                    FocusableIconButton2(
                      text: "이웃 이야기",
                      icon: Icons.people,
                      onClick: () => refresh(more: "neighbor"),
                      hasFocused: moreMethod == "neighbor",
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Divider(),
            const SizedBox(height: 2),
            Expanded(
              child: ListView.separated(
                controller: _scrollController,
                itemBuilder: (context, index) {
                  if (index < posts.length) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PostScreen(id: posts[index].id!)));
                        },
                        child: StoryItemLeftImg(
                          title: posts[index].title,
                          description: posts[index].description,
                          img: posts[index].img,
                          heart: posts[index].heart,
                          comment: posts[index].comment,
                          info: posts[index].info,
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
                separatorBuilder: (ctx, idx) => const SizedBox(height: 4),
                itemCount: posts.length + ((isLoading && hasMore) ? 1 : 0),
              ),
            ),
          ],
        ));
  }
}
