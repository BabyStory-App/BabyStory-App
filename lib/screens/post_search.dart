import 'package:flutter/material.dart';

class PostSearchScreen extends StatefulWidget {
  final String? searchWord;
  final int? initRevealState;

  const PostSearchScreen({Key? key, this.searchWord, this.initRevealState})
      : super(key: key);

  @override
  State<PostSearchScreen> createState() => _PostSearchState();
}

class _PostSearchState extends State<PostSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('PostSearchScreen'),
      ),
    );
  }
}
