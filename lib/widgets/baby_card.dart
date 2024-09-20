import 'package:babystory/apis/raws_api.dart';
import 'package:babystory/models/baby.dart';
import 'package:babystory/utils/date.dart';
import 'package:flutter/material.dart';

class BabyCard extends StatelessWidget {
  final Baby baby;

  const BabyCard({super.key, required this.baby});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 1,
            color: Colors.black12,
          )),
      width: 124,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage:
                  NetworkImage(RawsApi.getBabyProfileLink(baby.photoId)),
            ),
            const SizedBox(height: 14),
            Text(
              baby.name ?? baby.obn,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
                "${calculateMonthsUntilBirth(baby.birthDate).toString()}개월, ${baby.bloodType}",
                style: const TextStyle(fontSize: 11, color: Colors.black45)),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(baby.obn,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 11, color: Colors.black87)),
            ),
          ]),
    );
  }
}
