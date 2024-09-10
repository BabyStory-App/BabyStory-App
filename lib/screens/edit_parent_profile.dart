import 'dart:io';

import 'package:babystory/apis/raws_api.dart';
import 'package:babystory/enum/gender.dart';
import 'package:babystory/providers/parent.dart';
import 'package:babystory/utils/alert.dart';
import 'package:babystory/utils/http.dart';
import 'package:babystory/widgets/appbar/simple_closed_appbar.dart';
import 'package:babystory/widgets/input/label_dropdown1.dart';
import 'package:babystory/widgets/input/label_input1.dart';
import 'package:flutter/material.dart';
import 'package:babystory/models/parent.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditParentProfile extends StatefulWidget {
  const EditParentProfile({super.key});

  @override
  State<EditParentProfile> createState() => _EditParentProfileState();
}

class _EditParentProfileState extends State<EditParentProfile> {
  final HttpUtils httpUtils = HttpUtils();
  File? _image;
  final picker = ImagePicker();

  Parent getParentFromProvider() {
    final parent = context.read<ParentProvider>().parent;
    if (parent == null) {
      alertFailedUploadImage();
      throw Exception('Parent is null');
    }
    return parent;
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await addNewPhoto(_image!); // 비동기 작업에서는 BuildContext를 직접 사용하지 않음
    } else {
      print('No image selected.');
    }
  }

  Future<void> addNewPhoto(File imageFile) async {
    final parent = getParentFromProvider();

    try {
      var result = await httpUtils.postMultipart(
        url: '/parent/upload/profile',
        headers: {
          'Authorization': 'Bearer ${parent.jwt}',
        },
        filePath: imageFile.path,
      );

      if (result?['success'] == 200) {
        if (mounted) {
          updateProfile("photoId", result?['photoId']);
        }
      } else {
        alertFailedUploadImage();
      }
    } catch (e) {
      print('Error uploading photo: $e');
      alertFailedUploadImage();
    }
  }

  void alertFailedUploadImage() {
    if (mounted) {
      Alert.alert(
        context: context,
        title: "이미지 업로드에 실패하였습니다.",
        content: "jpg, png, tiff, webp, heif, heic 형식의 이미지만 업로드 가능합니다.",
      );
    }
  }

  void alertFailedUpdateProfile() {
    if (mounted) {
      Alert.alert(
        context: context,
        title: "프로필 수정에 실패하였습니다.",
        content: "잠시 후 다시 시도해주세요.",
      );
    }
  }

  Future<void> removePhoto() async {
    final parent = getParentFromProvider();
    Parent newParent = parent.copyWith();
    newParent.photoId = null;
    context.read<ParentProvider>().updateParent(newParent);
    newParent.printInfo();
    await updateServerProfile(newParent, "photoId", null);
  }

  Future<void> updateProfile<T extends Object?>(String key, T value) async {
    print("UpdateProfile { $key: $value }");
    final parent = getParentFromProvider();

    Parent newParent;

    switch (key) {
      case 'nickname':
        newParent = parent.copyWith(nickname: value as String);
        break;
      case 'name':
        newParent = parent.copyWith(name: value as String?);
        break;
      case 'photoId':
        newParent = parent.copyWith(photoId: value as String?);
        break;
      case 'description':
        newParent = parent.copyWith(description: value as String?);
        break;
      case 'mainAddr':
        newParent = parent.copyWith(mainAddr: value as String?);
        break;
      case 'subAddr':
        newParent = parent.copyWith(subAddr: value as String?);
        break;
      case 'gender':
        newParent = parent.copyWith(gender: value as Gender);
        break;
      default:
        throw Exception('Unknown key: $key');
    }

    context.read<ParentProvider>().updateParent(newParent);
    print("Update local parent infio");
    newParent.printInfo();
    await updateServerProfile(newParent, key, value);
  }

  Future<void> updateServerProfile<T extends Object?>(
      Parent parent, String key, T value) async {
    Map<String, dynamic> body = {key: value};
    if (value is Gender) {
      body['gender'] = genderToInt(value);
    }
    print("Send To Server $body");
    var response = await httpUtils.put(
      url: '/parent/',
      headers: {
        'Authorization': 'Bearer ${parent.jwt}',
      },
      body: key == 'photoId' && value == null
          ? {'photoId': 'remove_photoId'}
          : body,
    );
    print(response);
    if (response == null || response['success'] != 200) {
      alertFailedUpdateProfile();
    }
  }

  Future<void> updateGender(String? value) async {
    var gender = Gender.unknown;
    switch (value) {
      case "남성":
        gender = Gender.male;
        break;
      case "여성":
        gender = Gender.female;
        break;
    }
    updateProfile('gender', gender);
  }

  void deleteUser() async {
    final parent = getParentFromProvider();

    parent.printInfo();
    if (mounted) {
      Alert.confirmAlert(
        context: context,
        title: "정말로 삭제하시겠습니까?",
        content: "이 과정은 되돌릴 수 없습니다.",
        onAccept: () async {
          print("Delete user confirmed");
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final parent = getParentFromProvider();

    return Scaffold(
        appBar: const SimpleClosedAppBar(title: "프로필 수정"),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundImage: _image != null
                          ? FileImage(_image!) as ImageProvider<Object>
                          : NetworkImage(
                              RawsApi.getProfileLink(parent.photoId)),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("프로필 사진 수정",
                            style:
                                TextStyle(fontSize: 14, color: Colors.black87)),
                        const SizedBox(height: 2),
                        TextButton(
                          onPressed: parent.photoId != null
                              ? removePhoto
                              : () => pickImage(),
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              alignment: Alignment.centerLeft),
                          child: Text(
                              parent.photoId != null ? "사진 삭제" : "사진 추가",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: parent.photoId != null
                                      ? Colors.red
                                      : Colors.blue)),
                        ),
                      ],
                    )
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black.withOpacity(0.2),
                        width: 0.7, // 경계선 두께
                      ),
                    ),
                  ),
                  child: const SizedBox(width: double.infinity, height: 20),
                ),
                const SizedBox(height: 12),
                LabelInput1(
                    label: "이름",
                    hint: "이름을 입력해주세요",
                    value: parent.nickname,
                    onFocusOut: (value) => updateProfile('nickname', value)),
                LabelInput1(
                    label: "사용자 이름",
                    hint: "사용자 이름을 입력해주세요",
                    value: parent.name ?? "",
                    onFocusOut: (value) => updateProfile('name', value)),
                LabelDropdown1(
                    label: "성별",
                    options: genderKoreanList,
                    value: genderToKorean(parent.gender),
                    onSelected: (value) => updateGender(value)),
                LabelInput1(
                    label: "소개",
                    hint: "소개를 입력해주세요",
                    value: parent.description ?? "",
                    onFocusOut: (value) => updateProfile('description', value)),
                LabelDropdown1(
                    label: "메인 주소",
                    options: ["서울시 서초구", "서울시 은평구", "서울시 강남구", "사울시 마포구"],
                    value: parent.mainAddr ?? "서울시 강남구",
                    onSelected: (value) => updateProfile('mainAddr', value)),
                LabelInput1(
                    label: "상세 주소",
                    hint: "상세 주소를 입력해주세요",
                    value: parent.subAddr ?? "",
                    onFocusOut: (value) => updateProfile('subAddr', value)),
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: deleteUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(174, 204, 55, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      child: const Text(
                        '회원 탈퇴',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
