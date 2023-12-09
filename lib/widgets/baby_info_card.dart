import 'package:babystory/apis/raws_api.dart';
import 'package:babystory/models/baby.dart';
import 'package:babystory/utils/color.dart';
import 'package:babystory/widgets/avatar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class BabyInfoCard extends StatefulWidget {
  final Baby baby;
  const BabyInfoCard({super.key, required this.baby});

  @override
  State<BabyInfoCard> createState() => _BabyInfoCardState();
}

class _BabyInfoCardState extends State<BabyInfoCard> {
  XFile? imageFile;
  DateTime? birthDate;
  late String bloodTypeString = describeEnum(widget.baby.bloodType);
  late String genderString = describeEnum(widget.baby.gender);

  @override
  Widget build(BuildContext context) {
    widget.baby.printInfo();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(2, 4), // changes position of shadow
          ),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            Avatar(
                radius: 52,
                borderRadius: 3,
                avatarSize: 72,
                imageUri: RawsApi.getProfileLink(widget.baby.photoId),
                onImageChanged: (XFile? file) {
                  imageFile = file;
                }),
            const SizedBox(height: 32),
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
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      hintText: widget.baby.name,
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
                    items: GenderList.map<DropdownMenuItem<String>>(
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
                // underline input form
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
                    items: BloodTypeList.map<DropdownMenuItem<String>>(
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
                          .format(birthDate ?? widget.baby.birthDate),
                      style: const TextStyle(color: ColorProps.textBlack),
                    ),
                  ),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
