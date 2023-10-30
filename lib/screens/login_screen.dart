import 'package:babystory/screens/signup_screen.dart';
import 'package:babystory/utils/color.dart';
import 'package:babystory/utils/style.dart';
import 'package:babystory/widgets/inputForm.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorProps.bgWhite,
      body: Stack(
        children: [
          const Positioned(
            top: -150,
            right: -150,
            child: Opacity(
              opacity: 0.5,
              child: CircleAvatar(
                radius: 150,
                backgroundColor: ColorProps.bgPink,
              ),
            ),
          ),
          const Positioned(
            bottom: -150,
            left: -150,
            child: Opacity(
              opacity: 0.5,
              child:
                  CircleAvatar(radius: 150, backgroundColor: ColorProps.bgBlue),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.child_care,
                    size: 80,
                    color: ColorProps.pink,
                  ),
                  const SizedBox(height: 10),
                  const Text("Babystory", style: Style.titleText),
                  const SizedBox(height: 40),
                  const InputForm(hintText: "Email"),
                  const SizedBox(height: 20),
                  const InputForm(hintText: "Password"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupScreen()),
                        ),
                        child: const Text('회원 가입',
                            style: TextStyle(
                              color: ColorProps.lightblack,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            )),
                      )
                    ],
                  ),
                  const SizedBox(height: 44),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorProps.brown, // 따뜻한 색상
                      ),
                      child:
                          const Text("Login", style: TextStyle(fontSize: 17)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton.icon(
                      icon: Image.asset('assets/icons/google_sm.png',
                          width: 20, height: 20),
                      label: const Padding(
                        padding: EdgeInsets.only(left: 5, bottom: 3),
                        child: Text("Google로 로그인",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ),
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: ColorProps.lightgray),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
