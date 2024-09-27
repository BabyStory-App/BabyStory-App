import 'package:flutter/material.dart';

class UtilDivider extends StatelessWidget {
  final Color? color;
  final double paddingTop;
  final double paddingBottom;

  const UtilDivider({
    Key? key,
    this.color,
    this.paddingTop = 0,
    this.paddingBottom = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: paddingTop, bottom: paddingBottom),
      child: Container(
        height: 4,
        color: color ?? Colors.grey.withOpacity(0.2),
      ),
    );
  }
}
