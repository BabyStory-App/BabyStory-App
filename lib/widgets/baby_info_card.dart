import 'package:babystory/models/baby.dart';
import 'package:babystory/utils/color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BabyInfoCard extends StatefulWidget {
  final Baby baby;
  const BabyInfoCard({super.key, required this.baby});

  @override
  State<BabyInfoCard> createState() => _BabyInfoCardState();
}

class _BabyInfoCardState extends State<BabyInfoCard> {
  @override
  Widget build(BuildContext context) {
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
            Container(
                padding: const EdgeInsets.only(top: 28),
                width: 112,
                height: 140,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(90),
                    child: Image.network(
                      widget.baby.state.photoURL.isNotEmpty
                          ? widget.baby.state.photoURL[0]
                          : 'https://m.media-amazon.com/images/I/51SLlh1nW5L._AC_UF1000,1000_QL80_.jpg',
                      fit: BoxFit.cover,
                    ))),
            const SizedBox(height: 24),
            Row(
              children: [
                const SizedBox(
                  width: 64,
                  child: Text(
                    '이름: ',
                    style: TextStyle(
                        color: ColorProps.textgray,
                        fontSize: 16,
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
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                const SizedBox(width: 10),
                // underline input form
                Expanded(
                  child: DropdownMenu<String>(
                    width: 220,
                    inputDecorationTheme: const InputDecorationTheme(
                      border: UnderlineInputBorder(),
                    ),
                    initialSelection: describeEnum(widget.baby.gender),
                    onSelected: (String? value) {
                      // // This is called when the user selects an item.
                      // setState(() {
                      //   dropdownValue = value!;
                      // });
                    },
                    dropdownMenuEntries:
                        GenderList.map<DropdownMenuEntry<String>>(
                            (String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
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
                // underline input form
                Expanded(
                  child: DropdownMenu<String>(
                    width: 220,
                    inputDecorationTheme: const InputDecorationTheme(
                      border: UnderlineInputBorder(),
                    ),
                    initialSelection: describeEnum(widget.baby.bloodType),
                    onSelected: (String? value) {
                      // // This is called when the user selects an item.
                      // setState(() {
                      //   dropdownValue = value!;
                      // });
                    },
                    dropdownMenuEntries:
                        BloodTypeList.map<DropdownMenuEntry<String>>(
                            (String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
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
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now())
                        .then((selectedDate) {
                      setState(() {
                        // set state of birthDate
                      });
                    }),
                    child: Text(
                      DateFormat('yyyy-MM-dd').format(widget.baby.birthDate),
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
