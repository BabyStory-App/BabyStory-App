import 'package:flutter/material.dart';

class CryDetectScreen extends StatefulWidget {
  const CryDetectScreen({super.key});

  @override
  State<CryDetectScreen> createState() => _CryDetectScreenState();
}

class _CryDetectScreenState extends State<CryDetectScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: const Text('Cry detect Screen'),
    );
  }
}
