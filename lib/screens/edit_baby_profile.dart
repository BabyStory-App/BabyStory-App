import 'dart:io';
import 'package:babystory/apis/raws_api.dart';
import 'package:babystory/enum/gender.dart';
import 'package:babystory/models/baby.dart';
import 'package:babystory/providers/parent.dart';
import 'package:babystory/utils/alert.dart';
import 'package:babystory/utils/http.dart';
import 'package:babystory/widgets/appbar/simple_closed_appbar.dart';
import 'package:babystory/widgets/input/label_date_input1.dart';
import 'package:babystory/widgets/input/label_dropdown1.dart';
import 'package:babystory/widgets/input/label_input1.dart';
import 'package:babystory/widgets/input/label_num_input1.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditBabyProfile extends StatefulWidget {
  final Baby? baby;

  const EditBabyProfile({super.key, this.baby});

  @override
  State<EditBabyProfile> createState() => _EditBabyProfileState();
}

class _EditBabyProfileState extends State<EditBabyProfile> {
  final HttpUtils httpUtils = HttpUtils();
  File? _image;
  final picker = ImagePicker();
  late Baby baby;
  String imagePath = "";

  @override
  void initState() {
    super.initState();
    if (widget.baby != null) {
      baby = widget.baby!;
    } else {
      baby = Baby(
          id: 'tempCreateBabyId',
          obn: '',
          birthDate: DateTime.now(),
          gender: Gender.unknown,
          bloodType: " A+");
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await addNewPhoto(_image!);
    }
  }

  Future<void> addNewPhoto(File imageFile) async {
    this.imagePath = imageFile.path;
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
    baby.photoId = null;
  }

  Future<void> submitProfile() async {
    final parent = context.read<ParentProvider>().parent;
    Baby? resBaby;
    // baby.printInfo();

    if (widget.baby == null) {
      try {
        var result = await httpUtils.post(url: "/baby/create", headers: {
          'Authorization': 'Bearer ${parent?.jwt ?? ""}'
        }, body: {
          'obn': baby.obn,
          'name': baby.name,
          'gender': genderToInt(baby.gender),
          'birthDate': baby.birthDate.toIso8601String(),
          'bloodType': baby.bloodType,
          'cm': baby.cm.toString(),
          'kg': baby.kg.toString(),
        });
        if (result?['baby'] != null) {
          resBaby = Baby.fromJson(result!['baby']);
        } else {
          throw Exception("Failed to create baby");
        }
      } catch (e) {
        alertFailedUpdateProfile();
      }
    } else {
      try {
        var result = await httpUtils.put(url: "/baby/", headers: {
          'Authorization': 'Bearer ${parent?.jwt ?? ""}'
        }, body: {
          'baby_id': baby.id,
          'obn': baby.obn,
          'name': baby.name,
          'gender': genderToInt(baby.gender),
          'birthDate': baby.birthDate.toIso8601String(),
          'bloodType': baby.bloodType,
          'cm': baby.cm.toString(),
          'kg': baby.kg.toString(),
        });
        if (result?['baby'] != null) {
          resBaby = Baby.fromJson(result!['baby']);
          resBaby.printInfo();
        } else {
          throw Exception("Failed to create baby");
        }
      } catch (e) {
        alertFailedUpdateProfile();
      }
    }
    // resBaby?.printInfo();
    if (resBaby != null && imagePath.isNotEmpty) {
      try {
        var result = await httpUtils.postMultipart(
          url: '/baby/photoUpload',
          headers: {
            'Authorization': 'Bearer ${parent?.jwt ?? ""}',
          },
          fields: {
            'baby_id': resBaby.id,
          },
          filePath: imagePath,
        );
        if (result?['success'] != 200) {
          throw Exception("Failed to upload photo");
        }
        alertSuccess();
      } catch (e) {
        alertFailedUploadImage();
      }
    } else {
      alertSuccess();
    }
  }

  void alertSuccess() {
    Alert.alert(
        context: context,
        title: widget.baby == null ? "축하드립니다!" : "아이 프로필 수정 완료",
        content: "아이 프로필이 성공적으로 ${widget.baby == null ? "생성" : "수정"}하였습니다.",
        onAccept: navigate);
    Navigator.pop(context);
  }

  Future<void> navigate() async {
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SimpleClosedAppBar(
            title: widget.baby == null ? "아이 프로필 추가" : "아이 프로필 수정"),
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
                          : NetworkImage(RawsApi.getBabyProfileLink(
                              baby.photoId ?? baby.id)),
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
                          onPressed: baby.photoId != null
                              ? removePhoto
                              : () => pickImage(),
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              alignment: Alignment.centerLeft),
                          child: Text(
                              _image == null && baby.photoId == null
                                  ? "사진 추가"
                                  : "사진 삭제",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: _image == null && baby.photoId == null
                                      ? Colors.blue
                                      : Colors.red)),
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
                    label: "태명",
                    hint: "태명을 입력해주세요.",
                    value: baby.obn,
                    onFocusOut: (value) => baby.updateProfile("obn", value)),
                LabelInput1(
                    label: "이름",
                    hint: "이름을 입력해주세요.",
                    value: baby.name ?? "",
                    onFocusOut: (value) => baby.updateProfile("name", value)),
                LabelDropdown1(
                    label: "성별",
                    options: genderKoreanList,
                    value: genderToKorean(baby.gender),
                    onSelected: (value) => baby.updateProfile("gender", value)),
                LabelDateInput1(
                    label: "생년월일",
                    value: baby.birthDate,
                    onDateSelected: (value) =>
                        baby.updateProfile("birthDate", value)),
                LabelDropdown1(
                    label: "혈액형",
                    options: bloodTypeList,
                    value: bloodTypeList[0],
                    onSelected: (value) =>
                        baby.updateProfile("bloodType", value)),
                LabelNumInput1(
                    label: "키",
                    hint: "키을 입력해주세요.",
                    value: baby.cm ?? 0,
                    onFocusOut: (value) => baby.updateProfile("cm", value)),
                LabelNumInput1(
                    label: "몸무게",
                    hint: "몸무게을 입력해주세요.",
                    value: baby.kg ?? 0,
                    onFocusOut: (value) => baby.updateProfile("kg", value)),
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: submitProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(173, 95, 63, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      child: Text(
                        widget.baby == null ? '추가하기' : '수정하기',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
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
