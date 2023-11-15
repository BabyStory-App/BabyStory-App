import 'package:babystory/firebase_options.dart';
import 'package:babystory/screens/login.dart';
import 'package:babystory/widgets/router.dart';
import 'package:babystory/widgets/tf_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();

Future main() async {
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(
      options: await DefaultFirebaseOptions().defaultOptions());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const NavBarRouter();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
    // return const MaterialApp(
    //     home: Scaffold(
    //   body: TfTest(),
    // ));
  }
}
