import 'package:babystory/models/baby.dart';

enum SignInMethod {
  email,
  google,
}

class Perent {
  final String uid;
  String email;
  String nickname;
  final SignInMethod signInMethod;
  bool emailVerified;

  String? photoURL;
  List<Baby> babies;
  String? description;

  Perent({
    required this.uid,
    required this.email,
    required this.nickname,
    required this.signInMethod,
    this.photoURL,
    this.emailVerified = false,
    this.babies = const [],
    this.description,
  });

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
