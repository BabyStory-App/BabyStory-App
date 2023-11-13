import 'package:babystory/models/perent.dart';
import 'package:babystory/screens/edit_profile.dart';
import 'package:babystory/utils/color.dart';
import 'package:flutter/material.dart';

class UserProfileWidget extends StatelessWidget {
  final Perent perent;

  const UserProfileWidget({
    super.key,
    required this.perent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
            width: 48,
            height: 48,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.network(perent.photoURL ??
                    'https://qph.cf2.quoracdn.net/main-thumb-1529746431-200-ilmthkmwexpgmbqqgkiwdanovfosliym.jpeg'))),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(perent.nickname,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(221, 7, 6, 6))),
              const SizedBox(height: 2),
              Text(perent.description ?? '사랑으로 보살피는 부모',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.normal,
                    color: ColorProps.textgray,
                  )),
              const SizedBox(height: 2),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditProfileScreen()),
          ),
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
                color: ColorProps.bgWhite,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 1), // changes position of shadow
                  )
                ]),
            child: const Icon(
              Icons.edit,
              color: ColorProps.textBlack,
              size: 16,
            ),
          ),
        ),
        const SizedBox(width: 10)
      ],
    );
  }
}
