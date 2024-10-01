import 'package:babystory/apis/raws_api.dart';
import 'package:babystory/models/parent.dart';
import 'package:babystory/screens/post.dart';
import 'package:babystory/screens/post_search.dart';
import 'package:babystory/widgets/border_circle_avatar.dart';
import 'package:flutter/material.dart';

class PostMainBannerData {
  final int id;
  final String title;
  final String photoId;
  final String authorName;
  final String desc;

  PostMainBannerData({
    required this.id,
    required this.title,
    required this.photoId,
    required this.authorName,
    this.desc = "",
  });

  factory PostMainBannerData.fromJson(Map<String, dynamic> json) {
    return PostMainBannerData(
      id: json['postid'],
      title: json['title'],
      photoId: json['photoId'],
      authorName: json['author_name'],
      desc: json['desc'] ?? "",
    );
  }

  void printData() {
    debugPrint(
        'id: $id, title: $title, photoId: $photoId, authorName: $authorName, desc: $desc');
  }
}

class PostMainBanner extends StatefulWidget {
  final List<dynamic>? data;
  final Parent parent;

  const PostMainBanner({Key? key, required this.data, required this.parent})
      : super(key: key);

  @override
  _PostMainBannerState createState() => _PostMainBannerState();
}

class _PostMainBannerState extends State<PostMainBanner> {
  late List<PostMainBannerData> _data;
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    if (widget.data == null) {
      _data = [];
    } else {
      _data = widget.data!.map((e) => PostMainBannerData.fromJson(e)).toList();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Helper method to build individual banner pages
  Widget _buildBannerPage(PostMainBannerData bannerData) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PostScreen(id: bannerData.id)));
      },
      child: Stack(
        children: [
          Image.network(
            RawsApi.getPostLink(bannerData.photoId),
            width: double.infinity,
            height: 495,
            fit: BoxFit.cover,
          ),
          Container(
            width: double.infinity,
            height: 495,
            color: Colors.black.withOpacity(0.35),
          ),
          const Positioned(
            top: 24,
            left: 20,
            child: Text("BabyStory",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                )),
          ),
          Positioned(
            top: 24,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PostSearchScreen()));
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                BorderCircleAvatar(
                    image: widget.parent.photoId != null
                        ? NetworkImage(
                                RawsApi.getProfileLink(widget.parent.photoId))
                            as ImageProvider<Object>
                        : const AssetImage(
                            'assets/images/default_profile_image.jpeg')),
              ],
            ),
          ),
          Positioned(
            bottom: 66,
            left: 24,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bannerData.title.replaceAll('\n', ''),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    bannerData.desc.replaceAll('\n', ''),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "by. ${bannerData.authorName}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build the indicator dots
  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _data.length,
        (index) => Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == _currentIndex
                ? Colors.white
                : Colors.white.withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_data.isEmpty) {
      // Optionally, handle the empty state
      return Container(
        width: double.infinity,
        height: 495,
        color: Colors.grey[300],
        child: const Center(
          child: Text(
            "No banners available",
            style: TextStyle(color: Colors.black),
          ),
        ),
      );
    }

    return SizedBox(
      height: 495,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _data.length,
            onPageChanged: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return _buildBannerPage(_data[index]);
            },
          ),
          // Indicators at the bottom
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: _buildIndicators(),
          ),
        ],
      ),
    );
  }
}
