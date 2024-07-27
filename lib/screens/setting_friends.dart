import 'package:babystory/models/parent.dart';
import 'package:babystory/widgets/app_bar1.dart';
import 'package:babystory/widgets/friend_list_item.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class SettingFriends extends StatelessWidget {
  final String type;
  final parents = [
    Parent(
        uid: '1',
        nickname: '정다운1',
        email: 'wjdekdns1@email.com',
        signInMethod: SignInMethod.email,
        photoId: "0023/47741/baby-behaviour-and-awarenessnarrow.jpg",
        description: "두 아이를 키우고 있는 엄마가 쓰는 따뜻하고도 소박한 일상 이야기."),
    Parent(
        uid: '2',
        nickname: '정다운2',
        email: 'wjdekdns1@email.com',
        signInMethod: SignInMethod.email,
        photoId: "0023/47741/baby-behaviour-and-awarenessnarrow.jpg",
        description: "두 아이를 키우고 있는 엄마가 쓰는 따뜻하고도 소박한 일상 이야기."),
    Parent(
        uid: '3',
        nickname: '정다운3',
        email: 'wjdekdns1@email.com',
        signInMethod: SignInMethod.email,
        photoId: "0023/47741/baby-behaviour-and-awarenessnarrow.jpg",
        description: "두 아이를 키우고 있는 엄마가 쓰는 따뜻하고도 소박한 일상 이야기."),
    Parent(
        uid: '4',
        nickname: '정다운4',
        email: 'wjdekdns1@email.com',
        signInMethod: SignInMethod.email,
        photoId: "0023/47741/baby-behaviour-and-awarenessnarrow.jpg",
        description: "두 아이를 키우고 있는 엄마가 쓰는 따뜻하고도 소박한 일상 이야기."),
    Parent(
        uid: '5',
        nickname: '정다운5',
        email: 'wjdekdns1@email.com',
        signInMethod: SignInMethod.email,
        photoId: "0023/47741/baby-behaviour-and-awarenessnarrow.jpg",
        description: "두 아이를 키우고 있는 엄마가 쓰는 따뜻하고도 소박한 일상 이야기."),
  ];

  SettingFriends({super.key, required this.type});

  String getHeaderTitle() {
    return type == 'myMates' ? '나의 짝꿍' : '나의 친구들';
  }

  void handleMenuSelection(String value) {
    if (value == 'delete_all') {
      print('모두 삭제');
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: ListView.separated(
        itemCount: parents.length,
        itemBuilder: (BuildContext context, int index) => FriendListItem(
            parent: parents[index],
            displayAddButton: type != 'myMates',
            isMate: Random().nextBool()),
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
      ),
    );
  }
}
