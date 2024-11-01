import 'package:babystory/screens/post.dart';
import 'package:babystory/screens/post_profile.dart';
import 'package:flutter/material.dart';

class AlertMsgCreater {
  final String uid;
  final String nickname;
  final String? photoId;

  AlertMsgCreater({
    required this.uid,
    required this.nickname,
    this.photoId,
  });

  // from json
  factory AlertMsgCreater.fromJson(Map<String, dynamic> json) {
    return AlertMsgCreater(
      uid: json['parent_id'],
      nickname: json['nickname'],
      photoId: json['photo_id'],
    );
  }
}

class AlertMsg {
  final int id;
  final AlertMsgCreater creater;
  final String target; // 알림 온 종류 (팔로우, 게시물 하트 등)
  final String message;
  final Map<String, dynamic>? actionData;
  bool hasClicked; // 알림 클릭 여부

  AlertMsg({
    required this.id,
    required this.creater,
    required this.target,
    required this.message,
    this.hasClicked = false,
    this.actionData,
  });

  // from json
  factory AlertMsg.fromJson(Map<String, dynamic> json) {
    return AlertMsg(
        id: json['alert_id'],
        creater: AlertMsgCreater.fromJson(json['creater']),
        target: json['alert_type'],
        message: json['message'],
        actionData: json['action']);
  }

  void click() {
    hasClicked = true;
  }

  void printInfo() {
    print(
        "id: $id, creater: ${creater.nickname}, target: $target, message: $message, action: $actionData");
  }

  void action(BuildContext context) {
    if (actionData == null) {
      return;
    }
    switch (target) {
      case "post_heart":
      case "post_script":
      case "new_comment":
      case "subscribe_post":
        var postId = actionData!['post_id'];
        if (postId == null) {
          return;
        }
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PostScreen(id: postId)));
        break;
      case "new_friend":
        var parentId = actionData!['parent_id'];
        if (parentId == null) {
          return;
        }
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PostProfileScreen(parentId: parentId)));
        break;
    }
    hasClicked = true;
  }
}
