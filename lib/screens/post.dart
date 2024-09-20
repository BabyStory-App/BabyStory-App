import 'package:babystory/widgets/button/focusable_icon_button.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatelessWidget {
  final int id;
  const PostScreen({super.key, required this.id});

  final String content =
      '이제 돌이 지난 아이는, 집에 있는 책들 중에서 단연코 육아일기를 좋아한다. 사진 밑에 글을 적는 식으로 구 성되어 있는데, 자신의 얼굴이 나오니 흥미 있는지 계속 꺼내와서 보여달라고 한다. 나는 그 책을 읽어주며\n"이거 기억나? 네가 이렇게 했었지?"라고 하거나 "아이 이쁘다" 하면서 아이를 쓰다듬어주거나, "아빠가 어딨 어요?"라고 물어보며 다양하게 말을 걸어주고 있다.\n![[https://media.istockphoto.com/id/1277476795/photo/asian-parents-with-newborn-baby-closeup-portrait-of-asian-young-couple-father-mother-holding.jpg?s=612x612&w=0&k=20&c=9HI26nRvp3eLbstF6y0Qd8DFvRsb70WmVwK0RNJdX6U=]]아이를 키우면서 육아 일기를 꾸준히 쓰는 건 꽤나 피곤한 일이긴 하다. 주변에 비슷한 개월 수의 친구들이 많 은데, 육아일기를 쓰는 친구는 나 밖에 없는 걸 보면.. 확실하게 써야겠다는 의지가 없이 꾸준히 하는 건 어려 운 것 같다. 나 또한 매일 쓰지 못하기도 하고 밀려서 쓰는 경우가 다반사라서 세세한 기록을 하긴 어렵지만, 몰아서 썼다고 할지라도 네가 이랬었지라는 기억이 사진에 남아서 좋다. 육아일기에 사진이 들어가게 쓰다 보니 매일매일 아이의 일상을 사진으로 남기게 되는 것도 큰 장점이다.![[https://pimg.mk.co.kr/meet/neds/2022/06/image_readtop_2022_556367_16561184505086722.jpeg]]나는 나중에 육아일기를 통하여 아이 스스로 자신이 얼마나 귀하게 자란 존재인지를 알게 되기를 바란다. 아이가 생겼을 때 우리가 얼마나 기뻐했는지, 주변 사람들이 얼마나 축복을 해주었는지, 너를 출산한 날 얼마나기쁨이 가득했는지, 그리고 네가 행동하는 하나하나에 우리가 얼마나 환호했으며, 감동했는지. 그래서 아이가자랐을 때, 네가 무엇을 잘하고 못하고를 떠나서 그냥 너 자체로 환호받았던 순간들이 있었음을 알려주고 싶다. 그리고 나중에 아빠가 일하느라 바빠서 아이와 마주하는 시간이 짧아져 "아빠가 나한테 해준 게 뭐가 있어" 하는 순간이 온다면, 육아 일기 안에 이미 가득한 아빠의 사진을 보여주며 아빠 또한 너를 이렇게나 사랑했음을 보여주며 그 사랑을 확인시켜주고 싶다.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                  'https://media.istockphoto.com/id/1277476795/photo/asian-parents-with-newborn-baby-closeup-portrait-of-asian-young-couple-father-mother-holding.jpg?s=612x612&w=0&k=20&c=9HI26nRvp3eLbstF6y0Qd8DFvRsb70WmVwK0RNJdX6U=',
                  width: double.infinity,
                  height: 520,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: double.infinity,
                  height: 520,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 32,
                  left: 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 44,
                      height: 46,
                      padding: const EdgeInsets.only(right: 2),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black,
                        size: 26,
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 122,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '90일간의 육아일기',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '아기와 함께한 90일간의 여정.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Positioned(
                  bottom: 72,
                  left: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundImage: NetworkImage(
                            'https://tago.kr/images/sub/TG300-D02_img01.png'),
                      ),
                      SizedBox(width: 12),
                      Text(
                        '일론 머스크 · 조회수 312 · 3분 전',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(45),
                        topRight: Radius.circular(45),
                      ),
                    ),
                  ),
                )
              ],
            ),
            // Replace ListView with Column
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _parseContent(content),
              ),
            ),
            const SizedBox(height: 16),
            Container(
                decoration: BoxDecoration(
                    border: Border(
                  top: BorderSide(
                    color: Colors.grey.withOpacity(0.3),
                    width: 2,
                  ),
                )),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const CircleAvatar(
                              radius: 22,
                              backgroundImage: NetworkImage(
                                'https://tago.kr/images/sub/TG300-D02_img01.png',
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text('일론 머스크',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    )),
                                const SizedBox(height: 3),
                                Text('친구 183 · 이야기 32',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '삶은 나를 더 좋은 곳으로 데려가 그러니 믿고 따라가 보자. 파도치는 일상이 잔잔한 바다를 아름답게 만들어 주기에.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black.withOpacity(0.7),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FocusableIconButton(
                            icon: Icons.notifications_none_outlined,
                            label: '알림',
                            color: const Color(0xff608CFF),
                            onPressed: (isFocused) {
                              // TODO: Implement notification feature
                            },
                          ),
                          const SizedBox(width: 16),
                          FocusableIconButton(
                            icon: Icons.add,
                            label: '친구',
                            color: const Color(0xff608CFF),
                            onPressed: (isFocused) {
                              // TODO: Implement notification feature
                            },
                            focusIcon: Icons.check,
                            initFocusState: true,
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                )),
            const SizedBox(height: 24),
          ],
        ),
      ),
      // 하단 메뉴바
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  // TODO: Implement comment feature
                },
                child: const Row(children: [
                  Icon(Icons.favorite_outlined, color: Colors.red, size: 20),
                  SizedBox(width: 4),
                  Text('100',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      )),
                ]),
              ),
              const SizedBox(width: 6),
              const Text("|",
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold)),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () {
                  // TODO: Implement comment feature
                },
                child: const Row(children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.grey,
                    size: 20,
                  ),
                  SizedBox(width: 4),
                  Text('4',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      )),
                ]),
              ),
              IconButton(
                  onPressed: () {
                    // TODO: Implement share feature
                  },
                  icon: const Icon(Icons.share, color: Colors.grey, size: 18)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  // TODO: Implement script feature
                },
                child: const Row(children: [
                  Icon(
                    Icons.bookmark,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 2),
                  Text('82',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      )),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _parseContent(String content) {
    final regex = RegExp(r'!\[\[(.*?)\]\]|([^!\[\]\n]+)');
    final matches = regex.allMatches(content);
    List<Widget> widgets = [];

    for (final match in matches) {
      if (match.group(1) != null) {
        // Image match
        final imageUrl = match.group(1)!.trim();
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(imageUrl),
            ),
          ),
        );
      } else if (match.group(2) != null) {
        // Text match
        final text = match.group(2)!.trim();
        if (text.isNotEmpty) {
          widgets.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.8,
                ),
              ),
            ),
          );
        }
      }
    }

    return widgets;
  }
}
