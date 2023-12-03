import 'package:babystory/apis/raws_api.dart';
import 'package:babystory/models/parent.dart';
import 'package:babystory/screens/edit_profile.dart';
import 'package:babystory/utils/color.dart';
import 'package:flutter/material.dart';

class UserProfileWidget extends StatelessWidget {
  final Parent parent;

  const UserProfileWidget({
    super.key,
    required this.parent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: ColorProps.gray,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(40),
            ),
            width: 48,
            height: 48,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.network(RawsApi.getProfileLink(parent.photoURL)))),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(parent.nickname == '' ? '재원E' : parent.nickname,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(221, 7, 6, 6))),
              const SizedBox(height: 2),
              Text(parent.description ?? '사랑으로 보살피는 부모',
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
