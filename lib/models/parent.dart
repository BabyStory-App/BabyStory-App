import 'package:babystory/models/baby.dart';

enum SignInMethod {
  email,
  google,
}

List<String> SignInMethodList = SignInMethod.values.map((e) => e.name).toList();

class Parent {
  final String uid;
  String email;
  String nickname;
  final SignInMethod signInMethod;
  bool emailVerified;

  String? photoURL;
  List<Baby> babies;
  String? description;

  Parent({
    required this.uid,
    required this.email,
    required this.nickname,
    required this.signInMethod,
    this.emailVerified = false,
    this.photoURL,
    this.babies = const [],
    this.description,
  }) {
    babies = List<Baby>.empty();
  }

  void printUserinfo() {
    print('uid: $uid');
    print('email: $email');
    print('nickname: $nickname');
    print('signInMethod: $signInMethod');
    print('photoURL: $photoURL');
    print('emailVerified: $emailVerified');
    print('description: $description');
  }
}
