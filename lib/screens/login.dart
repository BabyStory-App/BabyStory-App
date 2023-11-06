import 'package:babystory/error/error.dart';
import 'package:babystory/screens/home.dart';
import 'package:babystory/screens/signup.dart';
import 'package:babystory/services/auth.dart';
import 'package:babystory/utils/alert.dart';
import 'package:babystory/utils/color.dart';
import 'package:babystory/utils/style.dart';
import 'package:babystory/utils/validate.dart';
import 'package:babystory/widgets/input_form.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthServices _authServices = AuthServices();

  void checkErrorAndNavigate(AuthError? authError) {
    if (authError != null) {
      if (!mounted) return;
      Alert.show(context, authError.message, () => false);
    }
    _authServices.user!.printUserinfo();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  Future<void> loginWithEmailAndPassword() async {
    // get three textfield values
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // check is empty
    if (Alert.show(context, '이메일을 입력해주세요.', () => email.isEmpty)) return;
    if (Alert.show(context, '비밀번호를 입력해주세요.', () => password.isEmpty)) return;

    // check if email is valid
    if (Alert.show(context, '이메일 형식이 올바르지 않습니다.',
        () => ValidateUtils.isEmail(email) == false)) return;

    // check if password is less than 6
    if (Alert.show(
        context, '비밀번호는 6자리 이상이어야 합니다.', () => password.length < 6)) {
      return;
    }

    AuthError? authError = await _authServices.loginWithEmailAndPassword(
        email: email, password: password);
    checkErrorAndNavigate(authError);
  }

  Future<void> loginWithGoogle() async {
    AuthError? authError = await _authServices.loginWithGoogle();
    checkErrorAndNavigate(authError);
  }

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
          LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 20.0),
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
                        InputForm(
                          hintText: "Email",
                          controller: _emailController,
                        ),
                        const SizedBox(height: 20),
                        InputForm(
                            hintText: "Password",
                            obscureText: true,
                            controller: _passwordController),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignupScreen()),
                              ),
                              child: const Text('회원가입',
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
                            onPressed: () => loginWithEmailAndPassword(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorProps.brown, // 따뜻한 색상
                            ),
                            child: const Text("Log in",
                                style: TextStyle(fontSize: 17)),
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ),
                            onPressed: () => loginWithGoogle(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              side:
                                  const BorderSide(color: ColorProps.lightgray),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
