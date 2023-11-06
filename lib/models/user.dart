enum SignInMethod {
  email,
  google,
}

class User {
  final String uid;
  String email;
  String nickname;
  final SignInMethod signInMethod;
  bool emailVerified;

  String? photoURL;

  User({
    required this.uid,
    required this.email,
    required this.nickname,
    required this.signInMethod,
    this.photoURL,
    this.emailVerified = false,
  });

  void printUserinfo() {
    print('uid: $uid');
    print('email: $email');
    print('nickname: $nickname');
    print('signInMethod: $signInMethod');
    print('photoURL: $photoURL');
    print('emailVerified: $emailVerified');
  }
}
