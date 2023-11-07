import 'package:babystory/screens/login.dart';
import 'package:babystory/screens/profile.dart';
import 'package:babystory/services/auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthServices _authServices = AuthServices();

  Future<void> signOut() async {
    // _authServices.signOut();
    if (!mounted) return;
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: GestureDetector(
          onTap: () => signOut(),
          child: const Text('Home'),
        ),
      ),
    );
  }
}
