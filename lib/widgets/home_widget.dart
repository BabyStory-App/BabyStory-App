import 'package:babystory/apis/baby_api.dart';
import 'package:babystory/apis/cry_api.dart';
import 'package:babystory/apis/raws_api.dart';
import 'package:babystory/models/baby.dart';
import 'package:babystory/models/parent.dart';
import 'package:babystory/screens/cry_detect.dart';
import 'package:babystory/utils/color.dart';
import 'package:babystory/widgets/cry_inspect_main.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class HomeWidget extends StatefulWidget {
  final Parent parent;
  final List<Baby> babies;
  const HomeWidget({super.key, required this.parent, required this.babies});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final CryApi _cryApi = CryApi();
  late Baby _selectedBaby = widget.babies[0];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '분석',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: ColorProps.textBlack),
            ),
            DropdownButtonHideUnderline(
                child: DropdownButton2(
              customButton: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ColorProps.bgPink,
                    width: 3.0,
                  ),
                  borderRadius: BorderRadius.circular(40),
                  color: ColorProps.orangeYellow,
                ),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                      RawsApi.getProfileLink(_selectedBaby.photoId)),
                ),
              ),
              items: widget.babies.map((baby) {
                return DropdownMenuItem(
                  value: baby,
                  child: Text(baby.name,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700)),
                );
              }).toList(),
              onChanged: (Baby? newValue) {
                setState(() {
                  _selectedBaby = newValue!;
                });
              },
              dropdownStyleData: DropdownStyleData(
                width: 140,
                padding: const EdgeInsets.symmetric(vertical: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorProps.orangeYellow,
                ),
                offset: const Offset(-85, 0),
              ),
            )),
          ],
        ),
        const SizedBox(
          height: 36,
        ),
        FutureBuilder(
          future: _cryApi.inspect(baby: widget.babies[0]),
          builder: (getBabyContext, getBabiesSnapshot) {
            if (getBabiesSnapshot.hasData &&
                getBabiesSnapshot.connectionState == ConnectionState.done) {
              if (getBabiesSnapshot.data!.isEmpty) {
                return Column(
                  children: [
                    const SizedBox(height: 120),
                    const Text(
                      '울음을 들려주세요!',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: ColorProps.textBlack),
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    const Text(
                      '아기의 울음 데이터를 분석해드립니다.',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ColorProps.textBlack),
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CryDetectScreen(
                                    parent: widget.parent,
                                  ))),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text('울음 감지하기'),
                    ),
                  ],
                );
              }
              return CryInspectMain(
                  selectedBaby: _selectedBaby,
                  inspectData: getBabiesSnapshot.data!);
            }
            return const Center(child: CircularProgressIndicator());
          },
        )
      ],
    );
  }
}
