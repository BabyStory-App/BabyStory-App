import 'package:babystory/apis/raws_api.dart';
import 'package:babystory/models/diary.dart';
import 'package:flutter/material.dart';

class DiaryCard extends StatelessWidget {
  final Diary diary;

  DiaryCard({super.key, required this.diary});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 104,
          height: 148,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffe0e0e0), width: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              RawsApi.getDiaryCoverLink(diary.photoId),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/splash.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(diary.title,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(204, 0, 0, 0)))
      ],
    );
  }
}
