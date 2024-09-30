import 'package:flutter/material.dart';

class FocusableIconButton2 extends StatelessWidget {
  final double height;
  final double width;
  final IconData icon;
  final String text;
  final Function()? onClick;
  final Color focusColor;
  final bool hasFocused;

  const FocusableIconButton2({
    Key? key,
    this.height = 28,
    this.width = 112,
    required this.icon,
    required this.text,
    this.onClick,
    this.focusColor = Colors.blue,
    this.hasFocused = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton.icon(
        onPressed: onClick,
        icon: Icon(icon,
            size: 16,
            color: hasFocused ? focusColor : Colors.grey), // Icon color
        label: Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text(
            text,
            style: TextStyle(
                fontSize: 12,
                color: hasFocused ? focusColor : Colors.black87), // Text color
          ),
        ),
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          backgroundColor: MaterialStateProperty.all(
              const Color.fromARGB(255, 246, 246, 246)), // Background color
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                  color: hasFocused
                      ? focusColor
                      : const Color.fromARGB(
                          255, 246, 246, 246)), // Border color
            ),
          ),
          overlayColor: MaterialStateProperty.all(
              Colors.transparent), // Remove ripple effect
        ),
      ),
    );
  }
}
