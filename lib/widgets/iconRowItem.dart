import 'package:flutter/material.dart';

class IconRowItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function()? onPressed;
  const IconRowItem(
      {super.key, required this.icon, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 26, color: Colors.black45),
          const SizedBox(width: 12),
          Text(text,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black))
        ],
      ),
    );
  }
}
