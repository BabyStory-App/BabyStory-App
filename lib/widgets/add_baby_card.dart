import 'package:babystory/utils/color.dart';
import 'package:flutter/material.dart';

class AddBabyCard extends StatelessWidget {
  const AddBabyCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: ColorProps.bgLightGray,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(2, 4),
            ),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                size: 48,
                color: ColorProps.textgray,
              ),
              SizedBox(height: 12),
              Text(
                '아기 추가하기',
                style: TextStyle(
                    color: ColorProps.textgray,
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ));
  }
}
