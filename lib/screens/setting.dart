import 'package:babystory/screens/login.dart';
import 'package:babystory/services/auth.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final AuthServices _auth = AuthServices();

  Future<void> signout() async {
    await _auth.signOut();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          TextButton(onPressed: () => signout(), child: const Text("Logout")),
    );
  }
}
