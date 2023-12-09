import 'package:babystory/models/cry_state.dart';
import 'package:babystory/utils/color.dart';
import 'package:babystory/widgets/cry_result.dart';
import 'package:flutter/material.dart';

class CryResultWrapperWidget extends StatelessWidget {
  final GlobalKey containerKey;
  final CryState? cryState;

  const CryResultWrapperWidget(
      {super.key, required this.containerKey, required this.cryState});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorProps.orangeYellow,
      height: MediaQuery.of(context).size.height * 1.2,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 32),
      key: containerKey,
      child: cryState == null
          ? const Center(
              child: Column(
              children: [
                Text(
                  '울음을 들려주세요',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
                SizedBox(
                  height: 48,
                ),
                Text(
                  '위 버튼을 눌러 울음을 들려주세요!',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '울음의 원인과 해결방안을 알려드려요!',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
                // going up icon with circle background with opcacity 0.4
                SizedBox(
                  height: 30,
                ),
                Icon(
                  Icons.arrow_circle_up,
                  size: 48,
                  color: Colors.black45,
                ),
              ],
            ))
          : Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: ColorProps.whiteOpacity03),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: CryResultWidget(cryState: cryState!),
            ),
    );
  }
}
