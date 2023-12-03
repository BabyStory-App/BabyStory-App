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
  String? jwt;

  Parent({
    required this.uid,
    required this.email,
    required this.nickname,
    required this.signInMethod,
    this.emailVerified = false,
    this.photoURL,
    this.babies = const [],
    this.description,
    this.jwt,
  }) {
    babies = List<Baby>.empty();
  }

  // from json
  factory Parent.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> parent = json['parent'];
    String jwt = json['x-jwt'];
    return Parent(
      uid: parent['uid'],
      email: parent['email'],
      nickname: parent['nickname'],
      signInMethod: SignInMethod.values.firstWhere(
          (e) => e.name == parent['signInMethod'],
          orElse: () => SignInMethod.email),
      emailVerified: parent['emailVerified'],
      photoURL: parent['photoId'],
      babies: [],
      description: parent['description'],
    );
  }

  void printUserinfo() {
    print('uid: $uid');
    print('email: $email');
    print('nickname: $nickname');
    print('signInMethod: $signInMethod');
    print('photoURL: $photoURL');
    print('emailVerified: $emailVerified');
    print('description: $description');
    print('jwt: $jwt');
  }

  void printInfo() {
    printUserinfo();
  }
}
