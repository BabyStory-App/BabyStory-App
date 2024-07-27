import 'package:flutter/material.dart';

class SessionTitle1 extends StatelessWidget {
  final String title;
  final String? buttonText;
  final Function()? onPressed;
  final bool setButtomLine;
  const SessionTitle1(
      {super.key,
      required this.title,
      this.buttonText,
      this.onPressed,
      this.setButtomLine = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
              if (buttonText != null && onPressed != null)
                OutlinedButton(
                    onPressed: onPressed,
                    style: OutlinedButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6)),
                    child: Text(
                      buttonText!,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ))
            ]),
        if (setButtomLine && buttonText == null) const SizedBox(height: 10),
        if (setButtomLine)
          Container(
            color: Colors.black12,
            width: double.infinity,
            height: 1,
          )
      ],
    );
  }
}
