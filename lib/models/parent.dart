import 'package:babystory/enum/gender.dart';

enum SignInMethod {
  email,
  google,
}

List<String> SignInMethodList = SignInMethod.values.map((e) => e.name).toList();

class Parent {
  final String uid;
  String nickname;
  String email;
  final SignInMethod signInMethod;
  bool emailVerified;
  Gender gender;

  String? name;
  String? photoId;
  String? description;
  String? mainAddr;
  String? subAddr;

  Parent({
    required this.uid,
    required this.nickname,
    required this.email,
    required this.signInMethod,
    this.emailVerified = false,
    this.gender = Gender.unknown,
    this.name,
    this.photoId,
    this.description,
    this.mainAddr,
    this.subAddr,
  });

  // from json
  factory Parent.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> parent = json['parent'];
    return Parent(
      uid: parent['parent_id'],
      nickname: parent['nickname'],
      email: parent['email'],
      signInMethod: SignInMethod.values.firstWhere(
          (e) => e.name == parent['signInMethod'],
          orElse: () => SignInMethod.email),
      emailVerified: parent['emailVerified'] == 1,
      gender: matchGender(parent['gender']),
      name: parent['name'],
      photoId: parent['photoId'],
      description: parent['description'],
      mainAddr: parent['mainAddr'],
      subAddr: parent['subAddr'],
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'parent_id': uid,
      'nickname': nickname,
      'email': email,
      'signInMethod': signInMethod.name,
      'emailVerified': emailVerified ? 1 : 0,
      'gender': gender.index,
      'name': name,
      'photoId': photoId,
      'description': description,
      'mainAddr': mainAddr,
      'subAddr': subAddr,
    };
  }

  void printUserinfo() {
    print('uid: $uid');
    print('nickname: $nickname');
    print('email: $email');
    print('signInMethod: $signInMethod');
    print('emailVerified: $emailVerified');
    print('gender: $gender');
    print('name: $name');
    print('photoId: $photoId');
    print('description: $description');
    print('mainAddr: $mainAddr');
    print('subAddr: $subAddr');
  }

  void printInfo() {
    printUserinfo();
  }
}
