import 'package:babystory/models/parent.dart';
import 'package:babystory/screens/profile.dart';
import 'package:babystory/utils/color.dart';
import 'package:flutter/material.dart';

class InspectBabyNotExist extends StatefulWidget {
  late Parent parent;

  InspectBabyNotExist({
    super.key,
    required Parent parent,
  });

  @override
  State<InspectBabyNotExist> createState() => _InspectBabyNotExistState();
}

class _InspectBabyNotExistState extends State<InspectBabyNotExist> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '분석',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: ColorProps.textBlack),
            ),
            IconButton(
              onPressed: () => {},
              icon: const Icon(Icons.face_retouching_natural_rounded),
              color: ColorProps.textBlack,
            )
          ],
        ),
        const SizedBox(
          height: 48,
        ),
        const Text(
          '아이를 추가해주세요!',
          style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: ColorProps.textBlack),
        ),
        const SizedBox(
          height: 48,
        ),
        const Text(
          '아이를 추가하면 아이의 상태를 분석할 수 있습니다.',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ColorProps.textBlack),
        ),
        const SizedBox(
          height: 48,
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfileScreen(
                    parent: widget.parent,
                  ))),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          child: const Text('아이 추가하기'),
        ),
      ],
    );
  }
}
