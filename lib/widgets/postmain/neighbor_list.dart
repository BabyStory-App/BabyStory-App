import 'package:babystory/screens/post_profile.dart';
import 'package:babystory/widgets/profile_card.dart';
import 'package:flutter/material.dart';

class PostmainNeighborList extends StatelessWidget {
  final List<dynamic>? data;

  const PostmainNeighborList({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data == null || data!.isEmpty) {
      return const SizedBox();
    }
    return Container(
        padding: const EdgeInsets.only(left: 16),
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: data!
                .map((neighbor) => Container(
                      margin: const EdgeInsets.only(right: 16),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PostProfileScreen(
                                      parentId: neighbor['parent_id'])));
                        },
                        child: ProfileCard(
                            parent: ProfileCardData.fromJson(neighbor)),
                      ),
                    ))
                .toList(),
          ),
        ));
  }
}
