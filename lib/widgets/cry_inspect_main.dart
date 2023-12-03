import 'package:babystory/models/baby.dart';
import 'package:babystory/screens/cry_list.dart';
import 'package:babystory/utils/color.dart';
import 'package:babystory/widgets/cry_page_navigate_widget.dart';
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
    return SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CryListScreen(baby: widget.selectedBaby),
                    ),
                  ),
              child: const CryPageNavigateWidget())
        ],
      ),
    );
  }
}
