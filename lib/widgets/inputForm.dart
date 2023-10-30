import 'package:flutter/material.dart';

class InputForm extends StatelessWidget {
  final String hintText;

  const InputForm({
    super.key,
    this.hintText = "",
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.brown[300], fontSize: 17),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 0.0, horizontal: 3.0),
      ),
    );
  }
}
