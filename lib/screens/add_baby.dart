import 'dart:io';

import 'package:babystory/models/baby.dart';
import 'package:babystory/utils/color.dart';
import 'package:babystory/widgets/avatar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddBabyScreen extends StatefulWidget {
  const AddBabyScreen({super.key});

  @override
  State<AddBabyScreen> createState() => _AddBabyScreenState();
}

class _AddBabyScreenState extends State<AddBabyScreen> {
  XFile? imageFile;
  String bloodTypeString = describeEnum(BloodType.unknown);
  String genderString = describeEnum(Gender.unknown);
  DateTime? birthDate;

  void addNewBaby() async {
    print(imageFile?.path ?? 'no image');
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
                          top: MediaQuery.of(context).size.height / 2 - 132,
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
                            const Row(
                              children: [
                                SizedBox(
                                  width: 64,
                                  child: Text(
                                    '이름: ',
                                    style: TextStyle(
                                        color: ColorProps.textgray,
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                SizedBox(width: 10),
                                // underline input form
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
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
                                        fontSize: 16,
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
                                        fontSize: 16,
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
                                        fontSize: 16,
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
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorProps.bgBrown,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                onPressed: () {
                                  // create new baby object
                                  // add baby object to baby list
                                  // pop screen
                                },
                                child: TextButton(
                                  onPressed: () => addNewBaby(),
                                  child: const Text('아기 추가하기',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: ColorProps.lightblack,
                                          fontWeight: FontWeight.w600)),
                                ),
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
