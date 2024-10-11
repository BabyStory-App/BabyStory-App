import 'package:babystory/models/parent.dart';
import 'package:babystory/providers/parent.dart';
import 'package:babystory/utils/http.dart';
import 'package:babystory/widgets/appbar/simple_closed_appbar.dart';
import 'package:babystory/widgets/comment_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final int postId;

  const CommentScreen({required this.postId, super.key});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final HttpUtils httpUtils = HttpUtils();
  final TextEditingController _commentController = TextEditingController();
  late Parent parent;
  late Future<List<CommentData>> comments;
  late int postId;
  CommentData? replyCommentData;

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
    postId = widget.postId;
    parent = getParentFromProvider();
    comments = fetchData();
  }

  Future<List<CommentData>> fetchData() async {
    try {
      var json = await httpUtils.get(
          url: '/pcomment/all/$postId',
          headers: {'Authorization': 'Bearer ${parent.jwt}'});
      var jsonComments = json['comments'] ?? [];
      // Convert jsonComments to a list of CommentData
      return List<CommentData>.from(
          jsonComments.map((e) => CommentData.fromJson(e)));
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  void postComment() async {
    final commentText = _commentController.text.trim();
    if (commentText.isNotEmpty) {
      try {
        var body = {'post_id': postId, 'content': commentText};
        if (replyCommentData != null) {
          body['reply_id'] = replyCommentData!.id;
        }
        await httpUtils.post(
          url: '/pcomment/create',
          headers: {'Authorization': 'Bearer ${parent.jwt}'},
          body: body,
        );
        setState(() {
          comments = fetchData();
        });
        _commentController.clear();
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  void onAddMoreComment(CommentData commentData) {
    debugPrint('onAddMoreComment: $commentData');
    setState(() {
      replyCommentData = commentData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleClosedAppBar(title: "댓글"),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<CommentData>>(
              future: comments,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: snapshot.data!
                            .map((e) => CommentItem(
                                data: e, onAddMoreComment: onAddMoreComment))
                            .toList(),
                      ),
                    ),
                  );
                } else {
                  return const Center(child: Text('Something went wrong'));
                }
              },
            ),
          ),
          if (replyCommentData != null)
            Container(
              decoration: BoxDecoration(
                border: const Border(
                  top: BorderSide(color: Colors.black38),
                ),
                color: Colors.black.withOpacity(0.04),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: CommentItem(
                    data: replyCommentData!,
                    showAddMoreCommentButton: false,
                    showReplies: false,
                    menuIcon: Icons.close,
                    onMorePressed: (data) {
                      setState(() {
                        replyCommentData = null;
                      });
                    }),
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: const BoxDecoration(
                border: Border(
              top: BorderSide(color: Colors.black12),
            )),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration.collapsed(
                      hintText: '이야기의 소감을 말해주세요.',
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: postComment,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(40, 50),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    alignment: Alignment.centerLeft,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black87, width: 0.5),
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      child: const Text('등록',
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
