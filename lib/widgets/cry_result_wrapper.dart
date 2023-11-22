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
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 32),
      key: containerKey,
      child: cryState == null
          ? const Center(
              child: Text('  울음이 감지되지 않았습니다.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  )))
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
