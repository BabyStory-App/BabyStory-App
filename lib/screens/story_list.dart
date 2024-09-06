import 'dart:math';
import 'package:babystory/screens/post.dart';
import 'package:babystory/utils/alert.dart';
import 'package:babystory/utils/date.dart';
import 'package:babystory/widgets/app_bar1.dart';
import 'package:babystory/widgets/appbar/appbar2.dart';
import 'package:babystory/widgets/storyItem/leftImg.dart';
import 'package:flutter/material.dart';

class StoryList extends StatefulWidget {
  final String? pageTitle;

  const StoryList({super.key, this.pageTitle});

  @override
  State<StoryList> createState() => _StoryListState();
}

class _StoryListState extends State<StoryList> {
  List<int> selectedItemIds = [];
  bool isSelecting = false;
  final stories = List.generate(
      10,
      (index) => Map.from({
            "id": Random().nextInt(1000),
            "title": "우리 아기의 첫 걸음!",
            "description":
                "아기가 첫 걸음을 내딛었어요! 뿌듯하네요. 그리고 아기가 첫 걸음을 내딛었어요! 뿌듯하네요. 그리고 아기가 첫 걸음을 내딛었어요! 뿌듯하네요. 그리고 아기가 첫 걸음을 내딛었어요! 뿌듯하네요. 그리고 아기가 첫 걸음을 내딛었어요! 뿌듯하네요. 그리고 아기가 첫 걸음을 내딛었어요! 뿌듯하네요. 그리고 아기가 첫 걸음을 내딛었어요! 뿌듯하네요. 그리고 아기가 첫 걸음을 내딛었어요! 뿌듯하네요. 그리고 아기가 첫 걸음을 내딛었어요! 뿌듯하네요.",
            "heart": Random().nextInt(100),
            "comment": Random().nextInt(100),
            "date": generateRandomDateTimeWithinOneMonth(),
            "img":
                "https://i0.wp.com/www.agencyreporter.com/wp-content/uploads/2019/09/baby-care-industry.jpg?fit=592%2C509&ssl=1",
          }));

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
                              PostScreen(id: stories[index]['id'])));
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
            stories.removeWhere(
                (element) => selectedItemIds.contains(element['id']));
            selectedItemIds.clear();
            isSelecting = false;
          });
        });
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
            itemCount: stories.length,
            itemBuilder: (BuildContext context, int index) => GestureDetector(
              onTap: isSelecting
                  ? () {
                      toggleSelection(stories[index]['id']);
                    }
                  : () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PostScreen(id: stories[index]['id'])));
                    },
              onLongPress: () => handleStoryLongPress(index),
              child: Row(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isSelecting
                        ? Checkbox(
                            key: ValueKey<int>(stories[index]['id']),
                            value:
                                selectedItemIds.contains(stories[index]['id']),
                            onChanged: (value) {
                              toggleSelection(stories[index]['id']);
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
                        title: stories[index]['title'],
                        description: stories[index]['description'],
                        img: stories[index]['img'],
                        heart: stories[index]['heart'],
                        comment: stories[index]['comment'],
                        date: stories[index]['date'],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            separatorBuilder: (BuildContext context, int index) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Divider(
                  color: Colors.black12,
                ),
              );
            },
          ),
        ));
  }
}
