import 'package:babystory/models/baby.dart';
import 'package:babystory/utils/color.dart';
import 'package:flutter/material.dart';

class CryInspectMain extends StatefulWidget {
  final Baby selectedBaby;

  const CryInspectMain({
    super.key,
    required this.selectedBaby,
  });

  @override
  State<CryInspectMain> createState() => _CryInspectMainState();
}

class _CryInspectMainState extends State<CryInspectMain> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.selectedBaby.name,
        style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: ColorProps.textBlack));
  }
}
