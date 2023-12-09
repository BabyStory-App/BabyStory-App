import 'dart:io';

import 'package:babystory/apis/baby_api.dart';
import 'package:babystory/models/baby.dart';
import 'package:babystory/models/parent.dart';
import 'package:babystory/utils/alert.dart';
import 'package:babystory/utils/color.dart';
import 'package:babystory/widgets/avatar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddBabyScreen extends StatefulWidget {
  final Parent parent;
  Function? onAddBaby;
  AddBabyScreen({super.key, required this.parent, this.onAddBaby});

  @override
  State<AddBabyScreen> createState() => _AddBabyScreenState();
}

class _AddBabyScreenState extends State<AddBabyScreen> {
  XFile? imageFile;
  String bloodTypeString = describeEnum(BloodType.unknown);
  String genderString = describeEnum(Gender.unknown);
  DateTime? birthDate;
  final TextEditingController _nameController = TextEditingController();
  final _babyApi = BabyApi();

  void addNewBaby() async {
    if (_nameController.text.isEmpty) {
      Alert.show(context, '아기의 이름을 입력해주세요.', () => false);
    } else if (birthDate == null) {
      Alert.show(context, '아기의 생년월일을 입력해주세요.', () => false);
    } else {
      var baby = await _babyApi.createBaby(
          createBabyInput: CreateBabyInput(
              name: _nameController.text,
              birthDate: birthDate!,
              genderString: genderString,
              bloodTypeString: bloodTypeString,
              photoUrl: imageFile?.path),
          parent: widget.parent);
      if (baby != null) {
        if (!mounted) return;
        await showDialog<void>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("축하합니다!"),
              content: Text("${baby.name} 아기가 등록되었습니다."),
              actions: <Widget>[
                TextButton(
                  child: const Text('확인'),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          },
        );
        if (!mounted) return;
        widget.onAddBaby?.call();
        Navigator.pop(context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // print("inside add baby screen");
    // widget.parent.printInfo();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // for fullscreen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

    return Scaffold(
      backgroundColor: ColorProps.bgWhite,
      body: Stack(
        children: [
          const Positioned(
            top: -150,
            left: -150,
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
            right: -150,
            child: Opacity(
              opacity: 0.5,
              child:
                  CircleAvatar(radius: 150, backgroundColor: ColorProps.bgBlue),
            ),
          ),
          LayoutBuilder(
              builder: (context, constraints) => SizedBox(
                    height: constraints.maxHeight,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 4,
                          bottom: 12,
                          left: 24,
                          right: 24,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Avatar(
                                radius: 66,
                                borderRadius: 3,
                                avatarSize: 88,
                                onImageChanged: (XFile? file) {
                                  imageFile = file;
                                }),
                            const SizedBox(height: 42),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 64,
                                  child: Text(
                                    '이름: ',
                                    style: TextStyle(
                                        color: ColorProps.textgray,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // underline input form
                                Expanded(
                                  child: TextField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                      border: UnderlineInputBorder(),
                                      hintText: "아기의 이름을 입력해주세요",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 64,
                                  child: Text(
                                    '성별: ',
                                    style: TextStyle(
                                        color: ColorProps.textgray,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    underline: Container(
                                      height: 1.5,
                                      color: ColorProps.gray,
                                    ),
                                    value: genderString,
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        setState(() {
                                          genderString = newValue;
                                        });
                                      }
                                    },
                                    items: GenderList.map<
                                            DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                          value: value, child: Text(value));
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 64,
                                  child: Text(
                                    '혈액형: ',
                                    style: TextStyle(
                                        color: ColorProps.textgray,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: DropdownButton<String>(
                                    underline: Container(
                                      height: 1.5,
                                      color: ColorProps.gray,
                                    ),
                                    isExpanded: true,
                                    value: bloodTypeString,
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        setState(() {
                                          bloodTypeString = newValue;
                                        });
                                      }
                                    },
                                    items: BloodTypeList.map<
                                            DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                          value: value, child: Text(value));
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 64,
                                  child: Text(
                                    '생년월일: ',
                                    style: TextStyle(
                                        color: ColorProps.textgray,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // underline input form
                                Expanded(
                                    child: Container(
                                  width: 220,
                                  alignment: Alignment.centerLeft,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                    color: ColorProps.textgray,
                                    width: 0.5,
                                  ))),
                                  child: TextButton(
                                    onPressed: () => showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime.now())
                                        .then((selectedDate) {
                                      setState(() {
                                        birthDate = selectedDate;
                                      });
                                    }),
                                    child: Text(
                                      DateFormat('yyyy-MM-dd')
                                          .format(birthDate ?? DateTime.now()),
                                      style: const TextStyle(
                                          color: ColorProps.textBlack),
                                    ),
                                  ),
                                )),
                              ],
                            ),
                            // Button to create new baby object
                            const SizedBox(height: 60),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: ColorProps.bgBrown,
                              ),
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () => addNewBaby(),
                                child: const Text('아기 추가하기',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: ColorProps.lightblack,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
