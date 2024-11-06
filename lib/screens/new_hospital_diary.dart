import 'package:babystory/models/baby.dart';
import 'package:babystory/models/parent.dart';
import 'package:babystory/providers/parent.dart';
import 'package:babystory/screens/hospital_diary_list.dart';
import 'package:babystory/utils/alert.dart';
import 'package:babystory/utils/http.dart';
import 'package:babystory/widgets/appbar/simple_closed_appbar.dart';
import 'package:babystory/widgets/input/label_num_input1.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewHospitalData {
  double? parentKg;
  double? pressure;
  double? babyKg;
  double? babyCm;
  Map<String, dynamic>? special;
  DateTime? nextDay;

  NewHospitalData({
    this.parentKg,
    this.pressure,
    this.babyKg,
    this.babyCm,
    this.special,
    this.nextDay,
  });

  dynamic get(String key) {
    switch (key) {
      case "parentKg":
        return parentKg;
      case "pressure":
        return pressure;
      case "babyKg":
        return babyKg;
      case "babyCm":
        return babyCm?.toInt();
      case "special":
        if (special == null || special!.isEmpty) return null;
        var specialValue = "";
        for (var key in special!.keys) {
          specialValue += "$key /split ${special![key]}  /seq ";
        }
        // remove last /seq
        specialValue = specialValue.substring(0, specialValue.length - 6);
        return specialValue;
      case "nextDay":
        return nextDay?.toIso8601String();
    }
  }

  void updateValue(String key, dynamic value) {
    switch (key) {
      case "parentKg":
        parentKg = value;
        break;
      case "pressure":
        pressure = value;
        break;
      case "babyKg":
        babyKg = value;
        break;
      case "babyCm":
        babyCm = value;
        break;
      case "special":
        special = value;
        break;
      case "nextDay":
        nextDay = value;
        break;
    }
  }
}

class NewHospitalDiaryScreen extends StatefulWidget {
  final int diaryId;
  final DateTime createDate;
  final Baby baby;

  const NewHospitalDiaryScreen(
      {Key? key,
      required this.diaryId,
      required this.createDate,
      required this.baby})
      : super(key: key);

  @override
  State<NewHospitalDiaryScreen> createState() => _NewHospitalDiaryScreenState();
}

class _NewHospitalDiaryScreenState extends State<NewHospitalDiaryScreen> {
  final HttpUtils httpUtils = HttpUtils();
  late Parent parent;
  NewHospitalData hospitalData = NewHospitalData();

  @override
  void initState() {
    super.initState();
    parent = getParentFromProvider();
  }

  Parent getParentFromProvider() {
    final parent = context.read<ParentProvider>().parent;
    if (parent == null) {
      throw Exception('Parent is null');
    }
    return parent;
  }

  Future<void> submitProfile() async {
    var parentKg = hospitalData.get("parentKg");
    var pressure = hospitalData.get("pressure");
    var babyKg = hospitalData.get("babyKg");
    var babyCm = hospitalData.get("babyCm");

    if (parentKg == null || pressure == null) {
      return;
    }

    try {
      var result = await httpUtils.post(url: '/hospital/create', headers: {
        'Authorization': 'Bearer ${parent.jwt}'
      }, body: {
        "diary_id": widget.diaryId,
        "createTime":
            "${widget.createDate.year}-${widget.createDate.month}-${widget.createDate.day}",
        "parent_kg": parentKg,
        "bpressure": pressure,
        "baby_kg": babyKg,
        "baby_cm": babyCm,
      });
      if (result != null) {
        if (!mounted) return;
        Alert.asyncAlert(
          context: context,
          title: "성공",
          content: "산모수첩이 추가되었습니다.",
          onAccept: (dialogContext) async {
            Navigator.of(dialogContext).pushReplacement(
              MaterialPageRoute(
                builder: (ctx) => HospitalDiaryListScreen(
                    diaryId: widget.diaryId, baby: widget.baby),
              ),
            );
          },
        );
      }
    } catch (e) {
      print(e);
      Alert.alert(
          context: context,
          title: "산모수첩 생성에 실패하였습니다.",
          content: "잠시 후 다시 시도해주세요.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleClosedAppBar(title: "산모수첩 추가"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LabelNumInput1(
                  label: "부모 몸무게",
                  hint: "부모 몸무게를 입력해주세요.",
                  value: hospitalData.parentKg ?? 0,
                  onFocusOut: (value) =>
                      hospitalData.updateValue("parentKg", value)),
              LabelNumInput1(
                  label: "혈압",
                  hint: "혈압을 입력해주세요.",
                  value: hospitalData.pressure ?? 0,
                  onFocusOut: (value) =>
                      hospitalData.updateValue("pressure", value)),
              LabelNumInput1(
                  label: "아기 몸무게",
                  hint: "아기 몸무게를 입력해주세요.",
                  value: hospitalData.babyKg ?? 0,
                  onFocusOut: (value) =>
                      hospitalData.updateValue("babyKg", value)),
              LabelNumInput1(
                  label: "아기 키",
                  hint: "아기 키을 입력해주세요.",
                  value: hospitalData.babyCm ?? 0,
                  onFocusOut: (value) =>
                      hospitalData.updateValue("babyCm", value)),
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
      ),
    );
  }
}
