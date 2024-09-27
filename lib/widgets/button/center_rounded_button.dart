import 'package:flutter/material.dart';

class CenterRoundedButton extends StatelessWidget {
  final double areaHeight;
  final String text;
  final Function onPressed;

  const CenterRoundedButton({
    Key? key,
    required this.areaHeight,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: areaHeight,
      child: Center(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0), // Rounded corners
            ),
            side: const BorderSide(color: Colors.grey), // Border color
            padding: const EdgeInsets.only(
                left: 26, right: 19, top: 0, bottom: 2), // Button padding
          ),
          onPressed: () => onPressed(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text, // Button text
                style: const TextStyle(
                  color: Colors.black, // Text color
                  fontSize: 12.0, // Text size
                ),
              ),
              const SizedBox(width: 2.0), // Space between text and icon
              const Padding(
                padding: EdgeInsets.only(top: 2.0),
                child: Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: Colors.black54, // Icon color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
