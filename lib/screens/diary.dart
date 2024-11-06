import 'package:babystory/models/baby.dart';
import 'package:babystory/models/parent.dart';
import 'package:babystory/providers/parent.dart';
import 'package:babystory/utils/http.dart';
import 'package:babystory/widgets/appbar/simple_closed_appbar.dart';
import 'package:babystory/widgets/diary/baby_diary_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  final HttpUtils httpUtils = HttpUtils();
  late Parent parent;
  late Future<List<Baby>> fetchDataFuture;

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

  Future<List<Baby>> fetchData() async {
    try {
      var json = await httpUtils.get(
          url: '/baby', headers: {'Authorization': 'Bearer ${parent.jwt}'});
      return json != null
          ? (json['baby'] as List).map((e) => Baby.fromJson(e)).toList()
          : [];
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleClosedAppBar(title: "육아일기", icon: null),
      body: FutureBuilder<List<Baby>>(
        future: fetchDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SingleChildScrollView(
                child: Column(
                  children: data
                      .map((baby) => BabyDiaryListView(baby: baby))
                      .toList(),
                ),
              ),
            );
          } else {
            return const Center(
              child: Text("아기를 등록해주세요,",
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
}
