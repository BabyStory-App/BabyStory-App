import 'package:flutter/material.dart';

class BoldCenterRoundedButton extends StatelessWidget {
  final double areaHeight;
  final double areaWidthRatio;
  final String text;
  final Function onPressed;

  const BoldCenterRoundedButton({
    Key? key,
    required this.areaHeight,
    this.areaWidthRatio = 0.9,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: areaHeight,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * areaWidthRatio,
            decoration: BoxDecoration(
              color: Colors.white, // Button color
              borderRadius: BorderRadius.circular(14.0),
              border: Border.all(
                color: Colors.black12, // Border color
                width: 2.0,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            height: areaHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text, // Button text
                  style: const TextStyle(
                      color: Colors.black87, // Text color
                      fontSize: 14.0, // Text size
                      fontWeight: FontWeight.bold),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: 24,
                  color: Color.fromARGB(255, 23, 143, 241), // Icon color
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
