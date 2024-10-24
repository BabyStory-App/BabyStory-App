import 'package:babystory/models/parent.dart';
import 'package:babystory/providers/parent.dart';
import 'package:babystory/utils/alert.dart';
import 'package:babystory/utils/http.dart';
import 'package:babystory/widgets/appbar/simple_closed_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatHospitalData {
  final double x;
  final double y;
  final String id;
  final String phone;
  final String url;
  final String name;
  final String address;
  final String? roadAddress;
  final String? category;

  ChatHospitalData({
    required this.x,
    required this.y,
    required this.id,
    required this.phone,
    required this.url,
    required this.name,
    required this.address,
    this.roadAddress,
    this.category,
  });

  factory ChatHospitalData.fromJson(Map<String, dynamic> json) {
    return ChatHospitalData(
      x: double.parse(json['x']),
      y: double.parse(json['y']),
      id: json['id'],
      phone: json['phone'],
      url: json['place_url'],
      name: json['place_name'],
      address: json['address_name'],
      roadAddress: json['road_address_name'],
      category: json['category_name'],
    );
  }
}

class ChatBubblePair {
  final int id;
  final String parentId;
  final int roomId;
  final DateTime createTime;
  final String ask;
  final String res;
  final ChatHospitalData? hospital;

  ChatBubblePair({
    required this.id,
    required this.parentId,
    required this.roomId,
    required this.createTime,
    required this.ask,
    required this.res,
    this.hospital,
  });

  factory ChatBubblePair.fromJson(Map<String, dynamic> json) {
    return ChatBubblePair(
      id: json['id'],
      parentId: json['parent_id'],
      roomId: json['room_id'],
      createTime: DateTime.parse(json['createTime']),
      ask: json['ask'],
      res: json['res'],
      hospital: json['hospital'] != null
          ? ChatHospitalData.fromJson(json['hospital'])
          : null,
    );
  }
}

class AiDoctorChatScreen extends StatefulWidget {
  final int? chatroomId;

  const AiDoctorChatScreen({Key? key, this.chatroomId}) : super(key: key);

  @override
  State<AiDoctorChatScreen> createState() => _AiDoctorChatScreenState();
}

class _AiDoctorChatScreenState extends State<AiDoctorChatScreen> {
  final HttpUtils httpUtils = HttpUtils();
  final TextEditingController _textInputController = TextEditingController();
  late Parent parent;
  late List<ChatBubblePair> chatBubbles;
  late double maxBubbleSize;
  late ScrollController _scrollController;
  bool _isLoading = false;

  Future<void> openKakaoMap(ChatHospitalData hospital) async {
    final Uri url = Uri.parse('kakaomap://place?id=${hospital.id}');
    try {
      var status = await launchUrl(url);
      if (!status) {
        throw Exception('Failed to open KakaoMap: ${hospital.id}');
      }
      return;
    } catch (e) {
      debugPrint("KakaoMap is not installed. Opening in browser.");
    }
    try {
      await launchUrl(Uri.parse(hospital.url));
    } catch (e) {
      debugPrint('Failed to open KakaoMap URL: ${hospital.url}');
    }
  }

  Future<List<ChatBubblePair>> getPreviousChats() async {
    try {
      if (widget.chatroomId != null) {
        var json = await httpUtils.get(
          url: '/aidoctor/chatroom?chatroom_id=${widget.chatroomId}',
          headers: {'Authorization': 'Bearer ${parent.jwt}'},
        );
        return (json['chatList'] as List)
            .map((e) => ChatBubblePair.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Parent getParentFromProvider() {
    final parent = context.read<ParentProvider>().parent;
    if (parent == null) {
      throw Exception('Parent is null');
    }
    return parent;
  }

  Future<void> askToAI() async {
    // Dismiss the keyboard
    FocusScope.of(context).unfocus();

    final text = _textInputController.text.trim();
    if (text.isEmpty) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      var body = {'ask': text};
      if (widget.chatroomId != null) {
        body['chatroom_id'] = widget.chatroomId.toString();
      }
      var json = await httpUtils.post(
        url: '/aidoctor/chat',
        headers: {'Authorization': 'Bearer ${parent.jwt}'},
        body: body,
      );
      if (json == null || json['chat'] == null) {
        if (mounted) {
          Alert.alert(
            context: context,
            title: "문제가 발생하였습니다.",
            content: "잠시 후에 다시 시도해주세요.",
          );
        }
        setState(() {
          _isLoading = false;
        });
        return;
      }
      var chatPair = ChatBubblePair.fromJson(json['chat']);
      setState(() {
        chatBubbles.add(chatPair);
        _isLoading = false;
      });
      _textInputController.clear();

      // Scroll to bottom after the new message is added
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    parent = getParentFromProvider();
    chatBubbles = [];
    _scrollController = ScrollController();
    _isLoading = false;
    getPreviousChats().then((value) {
      setState(() {
        chatBubbles = value;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    });
  }

  @override
  Widget build(BuildContext context) {
    maxBubbleSize = MediaQuery.of(context).size.width * 0.85;
    return Scaffold(
      appBar: const SimpleClosedAppBar(title: "AI 의사"),
      backgroundColor: const Color(0xffE9F3FF),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: chatBubbles.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: chatBubbles.length,
                        itemBuilder: (context, index) {
                          final chat = chatBubbles[index];
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width: maxBubbleSize,
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffACC1F9),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      chat.ask,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: maxBubbleSize,
                                    margin: const EdgeInsets.only(
                                        top: 10, left: 10),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 252, 252, 252),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      chat.res,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (chat.hospital == null &&
                                  index == chatBubbles.length - 1)
                                const SizedBox(height: 10),
                              chat.hospital != null
                                  ? Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            openKakaoMap(chat.hospital!);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: maxBubbleSize * 0.8,
                                                margin:
                                                    const EdgeInsets.all(10),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 16),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 228, 218, 255),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Row(
                                                      children: [
                                                        Icon(
                                                          Icons.local_hospital,
                                                          size: 16,
                                                          color: Colors.red,
                                                        ),
                                                        SizedBox(width: 5),
                                                        Text(
                                                          '인근 병원 정보',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 3),
                                                    Text(
                                                      chat.hospital!.name,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 3),
                                                    Text(
                                                      chat.hospital!.url,
                                                      style: const TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (index == chatBubbles.length - 1)
                                          const SizedBox(height: 10),
                                      ],
                                    )
                                  : const SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.black12),
                    bottom: BorderSide(color: Colors.black26),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _textInputController,
                        decoration: const InputDecoration.collapsed(
                          hintText: '궁금한 것을 물어보세요.',
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: askToAI,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(40, 50),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black87, width: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        child: const Text(
                          '등록',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.white.withOpacity(0.8),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
