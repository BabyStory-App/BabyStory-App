import 'package:babystory/models/baby.dart';
import 'package:babystory/models/hospital.dart';
import 'package:babystory/models/parent.dart';
import 'package:babystory/providers/parent.dart';
import 'package:babystory/screens/new_hospital_diary.dart';
import 'package:babystory/utils/http.dart';
import 'package:babystory/widgets/appbar/simple_closed_appbar.dart';
import 'package:babystory/widgets/date_picker_bottom_sheet.dart';
import 'package:babystory/widgets/diary/hospital_diary_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HospitalDiaryListScreen extends StatefulWidget {
  final int diaryId;
  final Baby baby;

  const HospitalDiaryListScreen(
      {Key? key, required this.diaryId, required this.baby})
      : super(key: key);

  @override
  State<HospitalDiaryListScreen> createState() =>
      _HospitalDiaryListScreenState();
}

class _HospitalDiaryListScreenState extends State<HospitalDiaryListScreen> {
  late DateTime startDate = DateTime.now().subtract(const Duration(days: 7));
  late DateTime endDate = DateTime.now();
  final HttpUtils httpUtils = HttpUtils();
  late Parent parent;
  late Future<List<Hospital>> fetchDataFuture;

  // Bottom Sheet를 통해 날짜 선택기 열기
  void _openDatePicker() async {
    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true, // 키보드가 올라올 때 Bottom Sheet가 전체를 덮도록
      builder: (BuildContext context) {
        return DatePickerBottomSheet();
      },
    );

    if (pickedDate != null) {
      print(pickedDate);
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewHospitalDiaryScreen(
              diaryId: widget.diaryId,
              createDate: pickedDate,
              baby: widget.baby,
            ),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    parent = getParentFromProvider();
    fetchDataFuture = fetchData();
  }

  Parent getParentFromProvider() {
    final parent = context.read<ParentProvider>().parent;
    if (parent == null) {
      throw Exception('Parent is null');
    }
    return parent;
  }

  Future<List<Hospital>> fetchData() async {
    try {
      var json = await httpUtils.get(
          url: '/hospital/all/${widget.diaryId}',
          headers: {'Authorization': 'Bearer ${parent.jwt}'});
      return json != null
          ? (json['hospitals'] as List)
              .map((e) => Hospital.fromJson(e))
              .toList()
          : [];
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SimpleClosedAppBar(
          title: "산모수첩",
          rightIcon: Icons.add,
          rightIconColor: Colors.blue,
          rightIconAction: () {
            _openDatePicker();
          }),
      body: FutureBuilder<List<Hospital>>(
        future: fetchDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            if (data.isEmpty) {
              return requestWriteHospital(context);
            }
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ListView.separated(
                itemCount: data.length,
                separatorBuilder: (BuildContext ctx, int idx) =>
                    const SizedBox(height: 12),
                itemBuilder: (BuildContext context, int index) =>
                    HospitalDiaryItem(hospital: data[index]),
              ),
            );
          } else {
            return requestWriteHospital(context);
          }
        },
      ),
    );
  }
}

Widget requestWriteHospital(BuildContext context) {
  return const Center(
    child: Text("산모수첩을 추가해주세요,",
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black45)),
  );
}
