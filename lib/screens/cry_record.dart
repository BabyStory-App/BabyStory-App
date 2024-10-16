import 'package:babystory/widgets/appbar/simple_closed_appbar.dart';
import 'package:flutter/material.dart';

class CryRecordScreen extends StatefulWidget {
  const CryRecordScreen({super.key});

  @override
  State<CryRecordScreen> createState() => _CryRecordScreenState();
}

class _CryRecordScreenState extends State<CryRecordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleClosedAppBar(title: "울음 기록"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('CryRecordScreen'),
          ],
        ),
      ),
    );
  }
}
