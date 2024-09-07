import 'package:babystory/utils/alert.dart';
import 'package:babystory/widgets/appbar/simple_closed_appbar.dart';
import 'package:babystory/widgets/input/label_dropdown1.dart';
import 'package:babystory/widgets/input/label_input1.dart';
import 'package:flutter/material.dart';
import 'package:babystory/models/parent.dart';

class EditParentProfile extends StatefulWidget {
  final Parent parent;

  const EditParentProfile({super.key, required this.parent});

  @override
  State<EditParentProfile> createState() => _EditParentProfileState();
}

class _EditParentProfileState extends State<EditParentProfile> {
  void addNewPhoto() {
    print("Add new photo");
  }

  Future<void> updateProfile<T extends Object?>(String key, T value) async {
    print("Update profile");
  }

  void deleteUser() {
    Alert.confirmAlert(
        context: context,
        title: "정말로 삭제하시겠습니까?",
        content: "이 과정은 되돌릴 수 없습니다.",
        onAccept: () async {
          print("Delete user confirmed");
        });
  }

  @override
  Widget build(BuildContext context) {
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
                    const CircleAvatar(
                      radius: 26,
                      backgroundImage: NetworkImage(
                          "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg"),
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
                          onPressed: addNewPhoto,
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              alignment: Alignment.centerLeft),
                          child: Text(
                              widget.parent.photoId == null ? "사진 삭제" : "사진 추가",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: widget.parent.photoId == null
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
                    value: widget.parent.nickname,
                    onFocusOut: (value) => updateProfile('nickname', value)),
                LabelInput1(
                    label: "사용자 이름",
                    hint: "사용자 이름을 입력해주세요",
                    value: widget.parent.name ?? "",
                    onFocusOut: (value) => updateProfile('name', value)),
                LabelDropdown1(
                    label: "성별",
                    options: ["남성", "여성", "비공개"],
                    value: "남성",
                    onSelected: (value) => updateProfile('gender', value)),
                LabelInput1(
                    label: "소개",
                    hint: "소개를 입력해주세요",
                    value: widget.parent.description ?? "",
                    onFocusOut: (value) => updateProfile('description', value)),
                LabelDropdown1(
                    label: "메인 주소",
                    options: ["서울시 서초구", "서울시 은평구", "서울시 강남구", "사울시 마포구"],
                    value: widget.parent.mainAddr ?? "서울시 강남구",
                    onSelected: (value) => updateProfile('mainAddr', value)),
                LabelInput1(
                    label: "상세 주소",
                    hint: "상세 주소를 입력해주세요",
                    value: widget.parent.subAddr ?? "",
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
