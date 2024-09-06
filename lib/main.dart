import 'package:babystory/firebase_options.dart';
import 'package:babystory/providers/parent.dart';
import 'package:babystory/screens/login.dart';
import 'package:babystory/widgets/router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 상태바의 배경색을 흰색으로, 텍스트와 아이콘 색상을 검정색으로 설정
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white, // 상태바의 배경색
    statusBarIconBrightness: Brightness.dark, // 상태바 아이콘 색상 (Android)
    statusBarBrightness: Brightness.dark, // 상태바 텍스트 색상 (iOS)
  ));

  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(
      options: await DefaultFirebaseOptions().defaultOptions());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ParentProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
            return const SafeArea(child: NavBarRouter());
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
