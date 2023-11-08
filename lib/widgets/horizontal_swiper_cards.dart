import 'package:flutter/material.dart';

class HorizontalSwiperCards extends StatefulWidget {
  final double height;
  final double viewportFraction;
  final double cardGap;
  final List<Widget> cards;
  final bool showIndicator;

  const HorizontalSwiperCards(
      {super.key,
      required this.cards,
      this.height = 435,
      this.viewportFraction = 0.9,
      this.cardGap = 4.0,
      this.showIndicator = true});

  @override
  State<HorizontalSwiperCards> createState() => _HorizontalSwiperCardsState();
}

class _HorizontalSwiperCardsState extends State<HorizontalSwiperCards> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.showIndicator ? widget.height : widget.height - 35,
          child: PageView.builder(
            itemCount: widget.cards.length,
            controller:
                PageController(viewportFraction: widget.viewportFraction),
            onPageChanged: (value) => setState(() {
              currentPage = value;
            }),
            itemBuilder: (BuildContext context, int itemIndex) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: widget.cardGap),
                child: Opacity(
                    opacity: currentPage != itemIndex ? 0.5 : 1,
                    child: widget.cards[itemIndex]),
              );
            },
          ),
        ),
        _indicator(
            context, widget.showIndicator, widget.cards.length, currentPage),
      ],
    );
  }
}

Widget _indicator(BuildContext context, bool showIndicator, int totalLength,
    int currentPage) {
  if (showIndicator == false) return const SizedBox(height: 0);

  return Column(
    children: [
      const SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<Widget>.generate(totalLength, (int index) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            width: 8.5,
            height: 8.5,
            decoration: BoxDecoration(
              color: index == currentPage ? Colors.blue : Colors.grey,
              shape: BoxShape.circle,
            ),
          );
        }),
      ),
    ],
  );
}
