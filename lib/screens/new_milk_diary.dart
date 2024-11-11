import 'package:babystory/models/baby.dart';
import 'package:babystory/models/parent.dart';
import 'package:babystory/providers/parent.dart';
import 'package:babystory/utils/alert.dart';
import 'package:babystory/utils/http.dart';
import 'package:babystory/widgets/appbar/simple_closed_appbar.dart';
import 'package:babystory/widgets/input/label_num_input1.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewMilkDiaryScreen extends StatefulWidget {
  final int diaryId;
  final DateTime createDate;
  final Baby baby;

  const NewMilkDiaryScreen(
      {Key? key,
      required this.diaryId,
      required this.createDate,
      required this.baby})
      : super(key: key);

  @override
  State<NewMilkDiaryScreen> createState() => _NewMilkDiaryScreenState();
}

class _NewMilkDiaryScreenState extends State<NewMilkDiaryScreen> {
  final HttpUtils httpUtils = HttpUtils();
  late Parent parent;

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
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
