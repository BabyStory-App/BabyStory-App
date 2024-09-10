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
  String? jwt;
  String? hashList;

  Parent(
      {required this.uid,
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
      this.hashList,
      this.jwt});

  Parent copyWith({
    String? uid,
    String? nickname,
    String? email,
    SignInMethod? signInMethod,
    bool? emailVerified,
    Gender? gender,
    String? name,
    String? photoId,
    String? description,
    String? mainAddr,
    String? subAddr,
    String? jwt,
    String? hashList,
  }) {
    return Parent(
      uid: uid ?? this.uid,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      signInMethod: signInMethod ?? this.signInMethod,
      emailVerified: emailVerified ?? this.emailVerified,
      gender: gender ?? this.gender,
      name: name ?? this.name,
      photoId: photoId ?? this.photoId,
      description: description ?? this.description,
      mainAddr: mainAddr ?? this.mainAddr,
      subAddr: subAddr ?? this.subAddr,
      jwt: jwt ?? this.jwt,
      hashList: hashList ?? this.hashList,
    );
  }

  // from json
  factory Parent.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> parent = json['parent'];
    return Parent(
      uid: parent['parent_id'],
      nickname: parent['nickname'],
      email: parent['email'],
      signInMethod: Parent.setSignInMethod(parent['signInMethod']),
      emailVerified: parent['emailVerified'],
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

  String getGenderSting() {
    return gender.toString().split('.').last;
  }

  static Gender setGender(int type) {
    switch (type) {
      case 0:
        return Gender.male;
      case 1:
        return Gender.female;
      default:
        return Gender.unknown;
    }
  }

  static SignInMethod setSignInMethod(String type) {
    switch (type) {
      case 'google':
        return SignInMethod.google;
      default:
        return SignInMethod.email;
    }
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
