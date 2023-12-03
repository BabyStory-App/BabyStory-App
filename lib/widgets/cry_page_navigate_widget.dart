import 'package:babystory/utils/color.dart';
import 'package:flutter/material.dart';

class CryPageNavigateWidget extends StatelessWidget {
  const CryPageNavigateWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: ColorProps.bgOrange,
        borderRadius: BorderRadius.circular(12),
      ),
      width: double.infinity,
      height: 88,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: ColorProps.whiteOpacity03,
                borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.baby_changing_station_rounded,
                color: Colors.white, size: 36),
          ),
          const SizedBox(width: 16),
          const Expanded(
              child: Padding(
            padding: EdgeInsets.only(bottom: 6),
            child: Text(
              '울음 보관소',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
          const Icon(Icons.arrow_forward_ios_rounded,
              color: Colors.white, size: 28),
        ],
      ),
    );
  }
}
