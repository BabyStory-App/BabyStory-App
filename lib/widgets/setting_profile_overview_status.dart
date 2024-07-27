import 'package:flutter/material.dart';

class SettingProfileOverviewStatus extends StatelessWidget {
  final String name;
  final int count;

  const SettingProfileOverviewStatus(
      {super.key, required this.name, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: const TextStyle(fontSize: 13, color: Colors.black38)),
        const SizedBox(height: 6),
        Text(count.toString(),
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87)),
      ],
    );
  }
}
