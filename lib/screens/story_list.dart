import 'package:babystory/apis/raws_api.dart';
import 'package:babystory/models/parent.dart';
import 'package:babystory/models/post.dart';
import 'package:babystory/providers/parent.dart';
import 'package:babystory/screens/post.dart';
import 'package:babystory/utils/alert.dart';
import 'package:babystory/utils/date.dart';
import 'package:babystory/utils/http.dart';
import 'package:babystory/widgets/app_bar1.dart';
import 'package:babystory/widgets/appbar/appbar2.dart';
import 'package:babystory/widgets/storyItem/leftImg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoryList extends StatefulWidget {
  final String? pageTitle;

  const StoryList({super.key, this.pageTitle});

  @override
  State<StoryList> createState() => _StoryListState();
}

class PostPreview extends Post {
  final String? photoId;
  final String contentPreview;

  PostPreview({
    required int id,
    required String parentId,
    PostReveal reveal = PostReveal.closed,
    required String title,
    required DateTime createTime,
    DateTime? modifyTime,
    DateTime? deleteTime,
    int? pHeart,
    int? pScript,
    int? pView,
    int? pComment,
    String? hashList,
    this.photoId,
    required this.contentPreview,
  }) : super(
          id: id,
          parentId: parentId,
          reveal: reveal,
          title: title,
          createTime: createTime,
          modifyTime: modifyTime,
          deleteTime: deleteTime,
          pHeart: pHeart,
          pScript: pScript,
          pView: pView,
          pComment: pComment,
          hashList: hashList,
        );
}

class _StoryListState extends State<StoryList> {
  final HttpUtils httpUtils = HttpUtils();
  List<PostPreview> stories = [];
  bool isSelecting = false;
  List<int> selectedItemIds = [];
  bool isLoading = false;
  bool hasMore = true;
  int currentPage = 0;
  final int pageSize = 10;
  final ScrollController _scrollController = ScrollController();

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
    fetchStories();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoading &&
          hasMore) {
        fetchStories();
      }
    });
  }

  String getEntryPointByTitle(String? title) {
    switch (title) {
      case "나의 이야기":
        return 'mystories';
      case "내가 저장한 이야기":
        return 'scripts';
      case "내가 읽은 이야기":
        return 'myviews';
      case "내가 좋아한 이야기":
        return 'likes';
      default:
        return 'mystories';
    }
  }

  Future<void> fetchStories() async {
    setState(() {
      isLoading = true;
    });

    final parent = getParentFromProvider();
    final response = await httpUtils.get(
        url: '/setting/${getEntryPointByTitle(widget.pageTitle)}/$currentPage',
        headers: {'Authorization': 'Bearer ${parent.jwt}'});
    print("Response: ");
    print(response);

    if (response['status'] == 'success') {
      final List<PostPreview> postPreviewList = (response['post'] as List)
          .map((post) => PostPreview(
                id: post['post_id'],
                title: post['title'],
                reveal: PostReveal.closed,
                parentId: "",
                createTime: DateTime.parse(post['createTime']),
                pHeart: post['pHeart'],
                pScript: post['pScript'],
                pView: post['pView'],
                pComment: post['pComment'],
                hashList: post['hashList'],
                photoId: post['photo_id'],
                contentPreview: post['contentPreview'],
              ))
          .toList();
      setState(() {
        currentPage++;
        hasMore = stories.length == pageSize;
        stories.addAll(postPreviewList);
      });
    } else {
      alertFail();
    }

    setState(() {
      isLoading = false;
    });
  }

  void alertFail() {
    if (mounted) {
      Alert.alert(
        context: context,
        title: "이야기를 불러오는데 실패했습니다.",
        content: "잠시 후 다시 시도해주세요.",
      );
    }
  }

  void handleMenuSelection(String value) {
    if (value == 'select_items') {
      setState(() {
        isSelecting = true;
        selectedItemIds.clear();
      });
    }
  }

  void toggleSelection(int id) {
    setState(() {
      if (selectedItemIds.contains(id)) {
        selectedItemIds.remove(id);
      } else {
        selectedItemIds.add(id);
      }
    });
  }

  void handleStoryLongPress(int index) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.remove_circle_outline),
                title: const Text('제거'),
                onTap: () {
                  Navigator.pop(context); // 팝업 닫기
                  setState(() {
                    stories.removeAt(index); // 해당 항목 제거
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.visibility),
                title: const Text('보기'),
                onTap: () {
                  Navigator.pop(context); // 팝업 닫기
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PostScreen(id: stories[index].id)));
                },
              ),
            ],
          );
        });
  }

  void deleteAllItems() {
    Alert.confirmAlert(
        context: context,
        title: "정말로 모두 제거하시겠습니까?",
        content: "이 작업은 되돌릴 수 없습니다.",
        onAccept: () async {
          setState(() {
            stories
                .removeWhere((element) => selectedItemIds.contains(element.id));
            selectedItemIds.clear();
            isSelecting = false;
          });
        });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.pageTitle != null
          ? (isSelecting
              ? AppBar2(
                  title: widget.pageTitle!,
                  onBackButtonPressed: () {
                    Navigator.pop(context);
                  },
                  menuIcon: const Icon(Icons.delete_outline,
                      color: Colors.redAccent, size: 20),
                  onMenuSelected: deleteAllItems,
                )
              : AppBar1(
                  title: widget.pageTitle!,
                  onBackButtonPressed: () {
                    Navigator.pop(context);
                  },
                  menuIcon: const Icon(Icons.more_vert,
                      color: Colors.black45, size: 20),
                  menuItems: const [
                    PopupMenuItem<String>(
                      value: 'select_items',
                      child: Text('선택'),
                    ),
                  ],
                  onMenuSelected: handleMenuSelection,
                )) as PreferredSizeWidget
          : null,
      body: Padding(
        padding:
            const EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 20),
        child: ListView.separated(
          controller: _scrollController,
          itemCount: stories.length + (hasMore ? 1 : 0),
          itemBuilder: (BuildContext context, int index) {
            if (index == stories.length) {
              // 로딩 인디케이터
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            final story = stories[index];
            return GestureDetector(
              onTap: isSelecting
                  ? () {
                      toggleSelection(stories[index].id);
                    }
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostScreen(id: story.id),
                        ),
                      );
                    },
              onLongPress: () => handleStoryLongPress(index),
              child: Row(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isSelecting
                        ? Checkbox(
                            key: ValueKey<int>(stories[index].id),
                            value: selectedItemIds.contains(stories[index].id),
                            onChanged: (value) {
                              toggleSelection(stories[index].id);
                            },
                          )
                        : const SizedBox.shrink(), // 선택 모드가 아닐 때는 빈 공간
                  ),
                  Expanded(
                    child: AnimatedContainer(
                      duration:
                          const Duration(milliseconds: 300), // 애니메이션 시간 설정
                      curve: Curves.easeInOut, // 자연스러운 애니메이션 곡선 설정
                      padding: EdgeInsets.only(
                          left: isSelecting ? 0 : 0), // 선택 모드일 때는 패딩 없음
                      margin: EdgeInsets.only(
                          left: isSelecting ? 10 : 0), // 선택 모드일 때만 왼쪽 여백 추가
                      child: StoryItemLeftImg(
                        title: stories[index].title,
                        description: stories[index].contentPreview,
                        img: stories[index].photoId,
                        heart: stories[index].pHeart,
                        comment: stories[index].pComment,
                        info: timeAgo(stories[index].createTime),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Divider(
                color: Colors.black12,
              ),
            );
          },
        ),
      ),
    );
  }
}
