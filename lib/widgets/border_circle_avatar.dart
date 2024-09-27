import 'package:flutter/material.dart';

class BorderCircleAvatar extends StatelessWidget {
  final double radius;
  final double borderWidth;
  final Color borderColor;
  final ImageProvider<Object> image;

  const BorderCircleAvatar({
    Key? key,
    this.radius = 15.0,
    this.borderWidth = 2.0,
    this.borderColor = Colors.white,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey,
        backgroundImage: image,
      ),
    );
  }
}
