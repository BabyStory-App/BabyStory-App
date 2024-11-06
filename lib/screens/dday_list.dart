import 'package:babystory/models/diary.dart';
import 'package:babystory/models/parent.dart';
import 'package:babystory/providers/parent.dart';
import 'package:babystory/screens/dday.dart';
import 'package:babystory/screens/dday_write.dart';
import 'package:babystory/utils/http.dart';
import 'package:babystory/widgets/appbar/simple_closed_appbar.dart';
import 'package:babystory/widgets/diary/diary_calendar.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DdayItem {
  final int id;
  final String title;
  final DateTime createTime;

  DdayItem({
    required this.id,
    required this.title,
    required this.createTime,
  });

  factory DdayItem.fromJson(Map<String, dynamic> json) {
    return DdayItem(
      id: json['dday_id'],
      title: json['title'],
      createTime: DateTime.parse(json['createTime']),
    );
  }
}

class DdayListScreen extends StatefulWidget {
  Diary diary;

  DdayListScreen({super.key, required this.diary});

  @override
  State<DdayListScreen> createState() => _DdayListScreenState();
}

class _DdayListScreenState extends State<DdayListScreen> {
  final HttpUtils httpUtils = HttpUtils();
  late Parent parent;
  late Future<List<DdayItem>> fetchDataFuture;

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

  Future<List<DdayItem>> fetchData() async {
    try {
      var json = await httpUtils.get(
          url: '/dday/all/${widget.diary.id}',
          headers: {'Authorization': 'Bearer ${parent.jwt}'});
      return json != null
          ? (json['dday'] as List).map((e) => DdayItem.fromJson(e)).toList()
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
          title: widget.diary.title,
          rightIcon: Icons.add,
          rightIconColor: Colors.blue,
          rightIconAction: () {
            showDialog(
              context: context,
              builder: (context) => DiaryCalendar(
                diaryId: widget.diary.id,
                jwt: parent.jwt!,
                initDate: DateTime.now(),
              ),
            );
          }),
      body: FutureBuilder<List<DdayItem>>(
        future: fetchDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            if (data.isEmpty) {
              return requestWriteDiary(context);
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: StickyGroupedListView<DdayItem, DateTime>(
                elements: data,
                groupBy: (DdayItem dday) =>
                    DateTime(dday.createTime.year, dday.createTime.month),
                groupSeparatorBuilder: (DdayItem dday) => Container(
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 249, 249, 249),
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black45,
                        width: 1,
                      ),
                      top: BorderSide(
                        color: Colors.black45,
                        width: 0.5,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${dday.createTime.year}-${dday.createTime.month.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                itemBuilder: (context, DdayItem dday) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DdayScreen(ddayId: dday.id)));
                  },
                  child: Container(
                    height: 62,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black12,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 40,
                            child: Text(
                                dday.createTime.day.toString().padLeft(2, '0'),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(156, 0, 0, 0))),
                          ),
                          const SizedBox(width: 8),
                          Text(dday.title,
                              style: const TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ),
                ),
                itemComparator: (DdayItem a, DdayItem b) =>
                    b.createTime.compareTo(a.createTime),
                groupComparator: (DateTime a, DateTime b) => b.compareTo(a),
                order: StickyGroupedListOrder.ASC,
              ),
            );
          } else {
            return requestWriteDiary(context);
          }
        },
      ),
    );
  }
}

Widget requestWriteDiary(BuildContext context) {
  return const Center(
    child: Text("일기를 작성해주세요,",
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black45)),
  );
}
