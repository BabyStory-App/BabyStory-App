import 'package:babystory/apis/raws_api.dart';
import 'package:babystory/models/baby.dart';
import 'package:babystory/models/diary.dart';
import 'package:babystory/models/parent.dart';
import 'package:babystory/providers/parent.dart';
import 'package:babystory/screens/dday_list.dart';
import 'package:babystory/screens/diary_add.dart';
import 'package:babystory/utils/http.dart';
import 'package:babystory/widgets/diary/diary_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BabyDiaryListView extends StatefulWidget {
  Baby baby;

  BabyDiaryListView({super.key, required this.baby});

  @override
  State<BabyDiaryListView> createState() => _BabyDiaryListViewState();
}

class _BabyDiaryListViewState extends State<BabyDiaryListView> {
  final HttpUtils httpUtils = HttpUtils();
  late Parent parent;
  late Future<List<Diary>> fetchDataFuture;
  bool canCreateMotherDiary = false;

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

  Future<List<Diary>> fetchData() async {
    try {
      var json = await httpUtils.get(
          url: '/diary/${widget.baby.id}',
          headers: {'Authorization': 'Bearer ${parent.jwt}'});
      if (json == null) {
        return [];
      }

      var diaryList =
          (json['diary'] as List).map((e) => Diary.fromJson(e)).toList();

      var tempCanCreateMotherDiary = true;
      for (var diary in diaryList) {
        if (diary.born == false) {
          tempCanCreateMotherDiary = false;
          break;
        }
      }
      if (tempCanCreateMotherDiary) {
        setState(() {
          canCreateMotherDiary = tempCanCreateMotherDiary;
        });
      }
      return diaryList;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Diary>>(
      future: fetchDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final diaries = snapshot.data!;
          for (var diary in diaries) {
            diary.printInfo();
          }
          return Padding(
            padding:
                const EdgeInsets.only(left: 18, right: 18, bottom: 8, top: 28),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor:
                              Colors.grey, // 이미지 로드 실패 시 사용할 기본 배경색
                          child: ClipOval(
                            child: Image.network(
                              RawsApi.getBabyProfileLink(widget.baby.photoId),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey, // 에러 시 회색으로 채우기
                                  child: const Icon(Icons.person,
                                      color: Colors
                                          .white), // 에러 시 기본 아이콘 표시 (선택 사항)
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 7.0),
                          child: Text(widget.baby.name ?? widget.baby.obn,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black)),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DiaryAddScreen(
                                    baby: widget.baby,
                                    canCreateMotherDiary:
                                        canCreateMotherDiary)));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 2.0),
                            child: Text("육아일기 추가",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.blue)),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_ios,
                              color: Colors.blue, size: 14),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                diaries.isEmpty
                    ? const Center(
                        child: Text("일기를 추가해주세요,",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45)),
                      )
                    : SizedBox(
                        height: 184,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: diaries.length,
                          itemBuilder: (BuildContext context, int index) =>
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DdayListScreen(
                                                    diary: diaries[index])));
                                  },
                                  child: DiaryCard(diary: diaries[index])),
                          separatorBuilder: (BuildContext ctx, int idx) =>
                              const SizedBox(width: 20),
                        ),
                      ),
              ],
            ),
          );
        }
      },
    );
  }
}
