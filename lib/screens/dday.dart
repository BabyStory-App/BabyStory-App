import 'package:babystory/apis/raws_api.dart';
import 'package:babystory/models/parent.dart';
import 'package:babystory/providers/parent.dart';
import 'package:babystory/screens/dday_write.dart';
import 'package:babystory/utils/alert.dart';
import 'package:babystory/utils/http.dart';
import 'package:babystory/widgets/appbar/simple_closed_appbar.dart';
import 'package:babystory/widgets/diary/diary_calendar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dday {
  final int id;
  final int diaryId;
  final String title;
  final String content;
  final List<String>? photoIds;
  final DateTime createTime;
  final DateTime? modifyTime;
  final Map<String, dynamic>? add;

  Dday({
    required this.id,
    required this.diaryId,
    required this.title,
    required this.content,
    this.photoIds,
    required this.createTime,
    this.modifyTime,
    this.add,
  });

  factory Dday.fromJson(Map<String, dynamic> json) {
    return Dday(
      id: json['dday_id'],
      diaryId: json['diary_id'],
      title: json['title'],
      content: json['content'],
      photoIds: json['photoId'] != null
          ? (json['photoId'] as List).map((e) => e.toString()).toList()
          : null,
      createTime: DateTime.parse(json['createTime']),
      modifyTime: json['modifyTime'] != null
          ? DateTime.parse(json['modifyTime'])
          : null,
      add: json['add'],
    );
  }

  void printInfo() {
    print(
        "\n\tid: $id\n\tdiaryId: $diaryId\n\ttitle: $title\n\tcontent: $content\n\tphotoIds: $photoIds\n\tcreateTime: $createTime\n\tmodifyTime: $modifyTime\n\tadd: $add");
  }
}

class DdayScreen extends StatefulWidget {
  int ddayId;

  DdayScreen({super.key, required this.ddayId});

  @override
  State<DdayScreen> createState() => _DdayScreenState();
}

class _DdayScreenState extends State<DdayScreen> {
  final HttpUtils httpUtils = HttpUtils();
  late Parent parent;
  late Future<Dday?> fetchDataFuture;
  late int? diaryId;
  String ddayTitle = "육아일기";
  DateTime date = DateTime.now();
  int? beforeDiaryId;
  int? nextDiaryId;

  @override
  void initState() {
    super.initState();
    parent = getParentFromProvider();
    fetchDataFuture = fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Parent getParentFromProvider() {
    final parent = context.read<ParentProvider>().parent;
    if (parent == null) {
      throw Exception('Parent is null');
    }
    return parent;
  }

  Future<Dday?> fetchData() async {
    try {
      var json = await httpUtils.get(
          url: '/dday/${widget.ddayId}',
          headers: {'Authorization': 'Bearer ${parent.jwt}'});
      if (json == null) return null;
      print("Response json: $json");
      var dday = json['dday'] != null ? Dday.fromJson(json['dday']) : null;
      if (dday != null) {
        diaryId = dday.diaryId;
        fetchHasDiary(dday.diaryId,
            dday.createTime.subtract(const Duration(days: 1)), true);
        fetchHasDiary(
            dday.diaryId, dday.createTime.add(const Duration(days: 1)), false);
        setState(() {
          ddayTitle = dday.title;
          date = dday.createTime;
        });
      }
      return dday;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  void fetchHasDiary(int diaryId, DateTime createTime, bool isBofore) async {
    try {
      var createTimeStr =
          "${createTime.year}-${createTime.month}-${createTime.day}";
      var json = await httpUtils.get(
          url: '/dday/$diaryId/$createTimeStr',
          headers: {'Authorization': 'Bearer ${parent.jwt}'});
      print("${isBofore ? 'before' : 'after'}: $json");
      if (json == null) return;
      if (json['dday'] != null) {
        if (isBofore) {
          setState(() {
            beforeDiaryId = json['dday']['dday_id'];
          });
        } else {
          setState(() {
            nextDiaryId = json['dday']['dday_id'];
          });
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  String getDateString(DateTime date) {
    return "${date.month.toString().padLeft(2, '0')}월 ${date.day.toString().padLeft(2, '0')}일";
  }

  void navigateCreate(bool isBefore) {
    if (!mounted) return;
    if (isBefore) {
      if (beforeDiaryId != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DdayScreen(ddayId: beforeDiaryId!)));
      } else {
        Alert.asyncConfirmAlert(
            context: context,
            title: "일기를 생성",
            content: "일기가 없습니다. 일기를 생성하시겠습니까?",
            onAccept: (dialogContext) async {
              await Navigator.of(dialogContext).pushReplacement(
                  MaterialPageRoute(
                      builder: (ctx) => DdayWriteScreen(
                          diaryId: diaryId!,
                          createTime: date.subtract(const Duration(days: 1)))));
            });
      }
    } else {
      if (nextDiaryId != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DdayScreen(ddayId: nextDiaryId!)));
      } else {
        Alert.asyncConfirmAlert(
            context: context,
            title: "일기를 생성",
            content: "일기가 없습니다. 일기를 생성하시겠습니까?",
            onAccept: (dialogContext) async {
              await Navigator.of(dialogContext).pushReplacement(
                  MaterialPageRoute(
                      builder: (ctx) => DdayWriteScreen(
                          diaryId: diaryId!,
                          createTime: date.add(const Duration(days: 1)))));
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleClosedAppBar(
        title: ddayTitle,
        setBottomBorder: false,
        iconAction: () async {
          if (mounted) {
            Navigator.pop(context);
          }
        },
      ),
      body: FutureBuilder<Dday?>(
        future: fetchDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final dday = snapshot.data!;
            return Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _parseContent(dday.content),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 253, 253, 253),
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black12,
                          width: 1,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            navigateCreate(true);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 3, right: 4),
                                child: Icon(Icons.arrow_back_ios_rounded,
                                    color: beforeDiaryId != null
                                        ? Colors.blue
                                        : Colors.grey,
                                    size: 16),
                              ),
                              Text(
                                  getDateString(
                                      date.subtract(const Duration(days: 1))),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: beforeDiaryId != null
                                          ? Colors.blue
                                          : Colors.grey)),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => DiaryCalendar(
                                diaryId: dday.diaryId,
                                jwt: parent.jwt!,
                                initDate: dday.createTime,
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                                "${date.year.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            navigateCreate(false);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                  getDateString(
                                      date.add(const Duration(days: 1))),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: nextDiaryId != null
                                          ? Colors.blue
                                          : Colors.grey)),
                              Padding(
                                padding: const EdgeInsets.only(top: 3, left: 4),
                                child: Icon(Icons.arrow_forward_ios_rounded,
                                    color: nextDiaryId != null
                                        ? Colors.blue
                                        : Colors.grey,
                                    size: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text("문제가 발생했습니다.\n다시 시도해주세요.,",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black45)),
            );
          }
        },
      ),
    );
  }

  List<Widget> _parseContent(String content) {
    final regex = RegExp(r'!\[\[(.*?)\]\]|([^!\[\]\n]+)');
    final matches = regex.allMatches(content);
    List<Widget> widgets = [];

    widgets.add(const SizedBox(height: 42));

    for (final match in matches) {
      if (match.group(1) != null) {
        // Image match
        final imageUrl = match.group(1)!.trim();
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(RawsApi.getDiaryImageLink(imageUrl),
                  width: double.infinity, height: 200, fit: BoxFit.cover),
            ),
          ),
        );
      } else if (match.group(2) != null) {
        // Text match
        final text = match.group(2)!.trim();
        if (text.isNotEmpty) {
          widgets.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.8,
                ),
              ),
            ),
          );
        }
      }
    }

    return widgets;
  }
}
