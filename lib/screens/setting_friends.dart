import 'package:babystory/providers/parent.dart';
import 'package:babystory/utils/http.dart';
import 'package:flutter/material.dart';
import 'package:babystory/models/parent.dart';
import 'package:babystory/widgets/app_bar1.dart';
import 'package:babystory/widgets/friend_list_item.dart';
import 'package:provider/provider.dart';

class SettingFriends extends StatefulWidget {
  final String type;

  const SettingFriends({super.key, required this.type});

  @override
  State<SettingFriends> createState() => _SettingFriendsState();
}

class SettingFriendItem {
  final String uid;
  final String nickname;
  final String? photoId;
  final String? description;
  final bool? isMate;

  SettingFriendItem({
    required this.uid,
    required this.nickname,
    this.photoId,
    this.description,
    this.isMate,
  });
}

class _SettingFriendsState extends State<SettingFriends> {
  final HttpUtils httpUtils = HttpUtils();
  List<SettingFriendItem> parents = [];
  late Parent parent;
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

  void toggleFriend(String friendUid) async {
    try {
      await httpUtils.post(url: '/friend/', headers: {
        'Authorization': 'Bearer ${parent.jwt}'
      }, body: {
        'friend': friendUid,
      });
    } catch (e) {
      debugPrint('Error toggling friend: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    parent = getParentFromProvider();
    _fetchFriends();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoading &&
          hasMore) {
        _fetchFriends();
      }
    });
  }

  Future<void> _fetchFriends() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      final response = await httpUtils.get(
          url:
              '/setting/${widget.type == 'myMates' ? 'mymates' : 'myfriends'}/$currentPage',
          headers: {'Authorization': 'Bearer ${parent.jwt}'});

      if (response['status'] == 'success') {
        final List<SettingFriendItem> fetchedParents =
            (response['parents'] as List)
                .map((item) => SettingFriendItem(
                      uid: item['parent_id'],
                      nickname: item['nickname'],
                      photoId: item['photoId'],
                      description: item['description'],
                      isMate: item['isMate'],
                    ))
                .toList();

        setState(() {
          currentPage += 1;
          hasMore = fetchedParents.length == pageSize;
          parents.addAll(fetchedParents);
        });
      } else {
        throw Exception('Failed to load friends');
      }
    } catch (error) {
      print('Error fetching friends: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String getHeaderTitle() {
    return widget.type == 'myMates' ? '나의 짝꿍' : '나의 친구들';
  }

  void handleMenuSelection(String value) {
    if (value == 'delete_all') {
      print('모두 삭제');
    }
  }

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < parents.length; i++) {
      print('${parents[i].nickname}: ${parents[i].isMate}');
    }
    return Scaffold(
      appBar: AppBar1(
        title: getHeaderTitle(),
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
        menuItems: const [
          PopupMenuItem<String>(
            value: 'delete_all',
            child: Text('모두 삭제'),
          ),
        ],
        onMenuSelected: handleMenuSelection,
      ),
      body: parents.isEmpty && isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              controller: _scrollController,
              itemCount: parents.length + (hasMore ? 1 : 0),
              itemBuilder: (BuildContext context, int index) {
                if (index == parents.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                return FriendListItem(
                  parent: parents[index],
                  displayAddButton: widget.type != 'myMates',
                  isMate: parents[index].isMate ?? false,
                  onAddButtonClicked: (String friendUid) {
                    toggleFriend(friendUid);
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
