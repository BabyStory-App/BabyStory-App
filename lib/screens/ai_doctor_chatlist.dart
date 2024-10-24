import 'package:babystory/models/parent.dart';
import 'package:babystory/providers/parent.dart';
import 'package:babystory/screens/ai_doctor_chat.dart';
import 'package:babystory/utils/http.dart';
import 'package:babystory/widgets/ai_doctor/chat_list_item.dart';
import 'package:babystory/widgets/appbar/simple_closed_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AiDoctorChatListScreen extends StatefulWidget {
  const AiDoctorChatListScreen({Key? key}) : super(key: key);

  @override
  State<AiDoctorChatListScreen> createState() => _AiDoctorChatListScreenState();
}

class _AiDoctorChatListScreenState extends State<AiDoctorChatListScreen> {
  final HttpUtils httpUtils = HttpUtils();
  late Parent parent;
  late Future<List<ChatListItemData>> fetchDataFuture;

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

  Future<List<ChatListItemData>> fetchData() async {
    try {
      var json = await httpUtils.get(
          url: '/aidoctor/mychatroom',
          headers: {'Authorization': 'Bearer ${parent.jwt}'});
      var res =
          json != null && json['chatrooms'] != null ? json['chatrooms'] : [];
      return List<ChatListItemData>.from(
          res.map((x) => ChatListItemData.fromJson(x)));
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleClosedAppBar(title: "나의 질문들"),
      body: FutureBuilder<List<ChatListItemData>>(
        future: fetchDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final items = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: ListView.separated(
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AiDoctorChatScreen(
                          chatroomId: items[index].id,
                        ),
                      ),
                    );
                  },
                  child: AiDoctorChatListItem(chat: items[index]),
                ),
                separatorBuilder: (ctx, idx) => const SizedBox(height: 16),
                itemCount: items.length,
              ),
            );
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }
}
