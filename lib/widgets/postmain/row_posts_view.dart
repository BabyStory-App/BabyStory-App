import 'package:babystory/widgets/row_posts_view.dart';
import 'package:flutter/material.dart';

class PostRowPostsView extends StatelessWidget {
  final List<dynamic>? data;
  late List<RowPostsViewData> _data;

  PostRowPostsView({super.key, required this.data}) {
    if (data == null) {
      _data = [];
    } else {
      _data = data!.map((e) => RowPostsViewData.fromJson(e)).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _data.isEmpty
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.only(bottom: 16, top: 4),
            child: RowPostsView(posts: _data),
          );
  }
}
