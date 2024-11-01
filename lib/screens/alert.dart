import 'package:babystory/apis/alert_api.dart';
import 'package:babystory/models/alert.dart';
import 'package:babystory/models/parent.dart';
import 'package:babystory/providers/parent.dart';
import 'package:babystory/utils/alert.dart';
import 'package:babystory/widgets/alert_item.dart';
import 'package:babystory/widgets/appbar/simple_closed_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  late Parent parent;
  late AlertApi alertApi;
  late Future<List<AlertMsg>> fetchDataFuture;
  List<int> ids = [];
  List<AlertMsg> items = []; // 상태에 아이템 리스트 추가
  bool isLoading = true; // 로딩 상태 관리

  @override
  void initState() {
    super.initState();
    parent = getParentFromProvider();
    alertApi = AlertApi(jwt: parent.jwt!);
    fetchData();
  }

  Parent getParentFromProvider() {
    final parent = context.read<ParentProvider>().parent;
    if (parent == null) {
      throw Exception('Parent is null');
    }
    return parent;
  }

  Future<void> fetchData() async {
    try {
      var results = await alertApi.getAlerts();
      setState(() {
        items = results;
        ids = results.map((e) => e.id).toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        items = [];
        isLoading = false;
      });
    }
  }

  void removeItem(int id) {
    setState(() {
      items.removeWhere((item) => item.id == id);
      ids.remove(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleClosedAppBar(
        title: "알림",
        rightIcon: Icons.check,
        rightIconAction: () {
          alertApi.checkMsg(ids);
          Alert.alert(
            context: context,
            title: "모든 알림 확인",
            content: "모든 알림을 확인하셨습니다.",
          );
          setState(() {
            items.clear();
            ids.clear();
          });
        },
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
              ? const Center(
                  child: Text('새로운 알림을 모두 확인하셨습니다.',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  itemBuilder: (itemContext, itemIndex) {
                    final alert = items[itemIndex];
                    return GestureDetector(
                      onTap: () {
                        alert.action(context);
                        alertApi.checkMsg([alert.id]);
                        removeItem(alert.id);
                      },
                      child: AlertItem(alertMsg: alert),
                    );
                  },
                  separatorBuilder: (seqCtx, seqIdx) =>
                      const SizedBox(height: 12),
                  itemCount: items.length,
                ),
    );
  }
}
