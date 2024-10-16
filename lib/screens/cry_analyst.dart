import 'package:babystory/widgets/appbar/simple_closed_appbar.dart';
import 'package:flutter/material.dart';

class CryAnalystScreen extends StatelessWidget {
  const CryAnalystScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleClosedAppBar(title: "울음 분석"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('CryAnalystScreen'),
          ],
        ),
      ),
    );
  }
}
