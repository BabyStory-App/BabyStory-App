import 'package:babystory/screens/post.dart';
import 'package:babystory/widgets/storyItem/leftImg.dart';
import 'package:flutter/material.dart';

class PostmainPostList extends StatelessWidget {
  final List<dynamic> data;

  const PostmainPostList({super.key, required this.data});

  Widget _buildItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostScreen(id: data[index]['postid']),
          ),
        );
      },
      child: Column(
        children: [
          StoryItemLeftImg(
            title: data[index]['title'],
            description: data[index]['desc'],
            img: data[index]['photoId'],
            heart: data[index]['pHeart'],
            comment: data[index]['comment'],
            info: data[index]['author_name'],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
      child: Column(
        children:
            data.map((e) => _buildItem(context, data.indexOf(e))).toList(),
      ),
    );
  }
}
