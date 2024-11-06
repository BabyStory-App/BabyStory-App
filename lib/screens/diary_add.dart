import 'dart:io';

import 'package:babystory/models/baby.dart';
import 'package:babystory/models/diary.dart';
import 'package:babystory/models/parent.dart';
import 'package:babystory/providers/parent.dart';
import 'package:babystory/screens/dday_list.dart';
import 'package:babystory/utils/alert.dart';
import 'package:babystory/utils/http.dart';
import 'package:babystory/widgets/appbar/simple_closed_appbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class DiaryAddScreen extends StatefulWidget {
  bool canCreateMotherDiary;
  Baby baby;

  DiaryAddScreen(
      {super.key, required this.baby, this.canCreateMotherDiary = false});

  @override
  State<DiaryAddScreen> createState() => _DiaryAddScreenState();
}

class _DiaryAddScreenState extends State<DiaryAddScreen> {
  final HttpUtils httpUtils = HttpUtils();
  final TextEditingController _controller = TextEditingController();
  File? _image;
  late Parent parent;
  final picker = ImagePicker();
  String imagePath = "";

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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await addNewPhoto(_image!);
    }
  }

  Future<void> addNewPhoto(File imageFile) async {
    this.imagePath = imageFile.path;
  }

  void alertFailed() {
    if (mounted) {
      Alert.alert(
        context: context,
        title: "일기 생성에 실패하였습니다.",
        content: "잠시 후 다시 시도해주세요.",
      );
    }
  }

  void alertSuccess(Diary newDiary) {
    Alert.asyncAlert(
        context: context,
        title: "${newDiary.title} 생성 완료!",
        content: "${newDiary.born ? '육아일기' : '산모수첩'}을 성공적으로 생성하였습니다.",
        onAccept: (dialogContext) async {
          Navigator.of(dialogContext).pushReplacement(
            MaterialPageRoute(
              builder: (ctx) =>
                  DdayListScreen(diary: newDiary, baby: widget.baby),
            ),
          );
        });
  }

  Future<void> navigate(Diary newDiary) async {
    if (!mounted) return;
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                DdayListScreen(diary: newDiary, baby: widget.baby)));
  }

  void _createDiary({bool isMotherDiary = false}) async {
    print("Create Diary");
    print(isMotherDiary);
    print(_controller.text);
    print(imagePath);

    Diary? newDiary;

    try {
      var json = await httpUtils.post(url: '/diary/create', headers: {
        'Authorization': 'Bearer ${parent.jwt ?? ""}'
      }, body: {
        "baby_id": widget.baby.id.toString(),
        'born': isMotherDiary ? 0 : 1,
        "title": _controller.text,
      });
      if (json == null) {
        alertFailed();
        return;
      }
      newDiary = Diary.fromJson(json['diary']);
      print("NewDiary");
      newDiary.printInfo();
    } catch (e) {
      alertFailed();
      return;
    }

    if (imagePath.isNotEmpty) {
      try {
        await httpUtils.postMultipart(
            url: '/diary/coverUpload',
            headers: {
              'Authorization': 'Bearer ${parent.jwt ?? ""}',
            },
            fields: {
              'diary_id': newDiary.id.toString(),
            },
            filePath: imagePath);
        newDiary.photoId = newDiary.id.toString();
      } catch (e) {
        print("Error in uploading image");
        print(e);
        alertFailed();
        return;
      }
    }

    alertSuccess(newDiary);
  }

  void createDiary() {
    if (!mounted) return;
    if (_controller.text.isEmpty) {
      Alert.alert(
        context: context,
        title: "일기 제목을 입력해주세요.",
        content: "",
      );
      return;
    }
    if (widget.canCreateMotherDiary) {
      Alert.selectionAlert<int>(
        context: context,
        title: '일기 생성 유형',
        content: '어떤 유형의 일기를 생성할지 선택해주세요!',
        items: [
          SelectionItem(name: '육아일기', value: 0),
          SelectionItem(name: '산모수첩', value: 1),
        ],
      ).then((value) {
        if (value == null) return;
        _createDiary(isMotherDiary: value == 0);
      });
    } else {
      _createDiary();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleClosedAppBar(
          title: "${widget.baby.name ?? widget.baby.obn}의 일기 추가"),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextField(
                  controller: _controller,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(
                    hintText: '제 목',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              GestureDetector(
                onTap: () => pickImage(),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.width * 0.85,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.5), width: 2),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: _image == null
                      ? const Icon(Icons.photo_album_outlined,
                          size: 72, color: Colors.grey)
                      : Image.file(_image!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 68),
              GestureDetector(
                onTap: () => createDiary(),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 202, 201, 201),
                        width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "일기 생성",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black.withOpacity(0.7),
                        fontWeight: FontWeight.bold),
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
