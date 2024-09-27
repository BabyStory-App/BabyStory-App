import 'package:flutter/material.dart';

class CircleIcon extends StatelessWidget {
  final double radius;
  final double borderWidth;
  final IconData icon;
  final double iconSize;
  final bool hasChecked;

  const CircleIcon({
    Key? key,
    this.radius = 12,
    this.borderWidth = 1.5,
    required this.icon,
    this.iconSize = 18,
    this.hasChecked = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: hasChecked ? Colors.red : Colors.grey.withOpacity(0.5),
          width: borderWidth,
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: iconSize,
          color: hasChecked ? Colors.red : Colors.grey.withOpacity(0.5),
        ),
      ),
    );
  }
}
