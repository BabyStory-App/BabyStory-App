import 'package:babystory/models/baby.dart';
import 'package:flutter/material.dart';

class CryListScreen extends StatefulWidget {
  final Baby baby;

  const CryListScreen({super.key, required this.baby});

  @override
  State<CryListScreen> createState() => _CryListScreenState();
}

class _CryListScreenState extends State<CryListScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
