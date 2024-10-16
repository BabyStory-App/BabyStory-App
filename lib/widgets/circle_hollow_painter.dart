import 'package:flutter/material.dart';

class CircleHollowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerCircle = Offset(size.width / 2, size.height / 2);

    const innerRadius = 76.0;
    const outerRadius = 88.0;

    final outerPath = Path()
      ..addOval(Rect.fromCircle(center: centerCircle, radius: outerRadius));
    final innerPath = Path()
      ..addOval(Rect.fromCircle(center: centerCircle, radius: innerRadius));

    const gradient = SweepGradient(
      colors: [
        Color.fromRGBO(255, 219, 140, 0.851),
        Color.fromRGBO(255, 100, 100, 0.851),
        Color.fromRGBO(255, 199, 110, 0.851),
        Color.fromRGBO(255, 150, 200, 0.851),
        Color.fromRGBO(235, 179, 90, 0.851),
      ],
      stops: [0.0, 0.25, 0.5, 0.75, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(
          Rect.fromCircle(center: centerCircle, radius: outerRadius))
      ..style = PaintingStyle.fill;

    final hollowCircle =
        Path.combine(PathOperation.difference, outerPath, innerPath);

    canvas.drawPath(hollowCircle, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
