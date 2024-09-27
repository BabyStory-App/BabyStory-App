import 'package:babystory/models/parent.dart';
import 'package:babystory/providers/parent.dart';
import 'package:babystory/screens/post.dart';
import 'package:babystory/utils/http.dart';
import 'package:babystory/widgets/storyItem/leftImg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ParentPostList extends StatefulWidget {
  final String parentId;
  final int limit;

  const ParentPostList({Key? key, required this.parentId, this.limit = 999})
      : super(key: key);

  @override
  State<ParentPostList> createState() => _ParentPostListState();
}

class _ParentPostListState extends State<ParentPostList> {
  final HttpUtils httpUtils = HttpUtils();
  late Parent parent;
  late Future<List<dynamic>> fetchDataFuture; // Updated type

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

  Future<List<dynamic>> fetchData() async {
    // Updated return type
    try {
      var json = await httpUtils.get(
        url: '/post/parent/${widget.parentId}/${widget.limit}',
        headers: {'Authorization': 'Bearer ${parent.jwt}'},
      );
      if (json is List) {
        return json;
      } else {
        throw Exception('Unexpected JSON format');
      }
    } catch (e) {
      debugPrint(e.toString());
      return []; // Return an empty list on error to prevent crashes
    }
  }

  Widget _buildItem(BuildContext context, Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostScreen(id: data['postid']),
          ),
        );
      },
      child: Column(
        children: [
          StoryItemLeftImg(
            title: data['title'],
            description: data['desc'],
            img: data['photoId'],
            heart: data['pHeart'],
            comment: data['comment'],
            info: data['author_name'],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final dataList = snapshot.data!;
          if (dataList.isEmpty) {
            return const Center(child: Text('No posts available.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            shrinkWrap: true, // Added
            physics: const NeverScrollableScrollPhysics(), // Added
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              final data = dataList[index];
              if (data is Map<String, dynamic>) {
                return _buildItem(context, data);
              } else {
                return const SizedBox(); // Handle unexpected data types
              }
            },
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
