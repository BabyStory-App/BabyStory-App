import 'package:babystory/models/parent.dart';
import 'package:babystory/providers/parent.dart';
import 'package:babystory/screens/ai_doctor_chatlist.dart';
import 'package:babystory/widgets/ai_doctor/recommand_card.dart';
import 'package:babystory/widgets/appbar/simple_closed_appbar.dart';
import 'package:babystory/widgets/button/bold_center_rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AiDoctorMain extends StatefulWidget {
  const AiDoctorMain({super.key});

  @override
  State<AiDoctorMain> createState() => _AiDoctorMainState();
}

class _AiDoctorMainState extends State<AiDoctorMain> {
  late Parent parent;

  Parent getParentFromProvider() {
    final parent = context.read<ParentProvider>().parent;
    if (parent == null) {
      throw Exception('Parent is null');
    }
    return parent;
  }

  @override
  void initState() {
    super.initState();
    parent = getParentFromProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleClosedAppBar(
        title: 'AI 의사',
        iconColor: Colors.white,
        iconAction: () {},
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BoldCenterRoundedButton(
                areaHeight: 56,
                text: "내가 물어본 질문들",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AiDoctorChatList(parent: parent)));
                }),
            const SizedBox(height: 8),
            SizedBox(
              height: 360, // Set a fixed height for GridView
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                physics:
                    const NeverScrollableScrollPhysics(), // Prevent scrolling inside GridView
                children: List.generate(
                    4,
                    (index) => AiDoctorRecommandCard(
                        cardData: recommandCardDataList[index])),
              ),
            ),
            Image.asset(
              'assets/ai_doctor_botton.png',
            )
          ],
        ),
      ),
    );
  }
}

List<AiDoctorRecommandCardData> recommandCardDataList = [
  AiDoctorRecommandCardData(
    title: '긴급 상황이에요!',
    description: '갑작스러운 증상이 있나요?\n원인 모를 긴급 상황에, AI 의사가 도움을 드릴께요!',
    icon: const Icon(Icons.medical_services, color: Colors.redAccent, size: 32),
  ),
  AiDoctorRecommandCardData(
    title: '영유아 성장',
    description: '아기의 발달 단계와 성장에 대해 궁금하신가요?\n AI의사가 알려드릴께요!',
    icon: const Icon(Icons.directions_run, color: Colors.green, size: 32),
  ),
  AiDoctorRecommandCardData(
    title: '아기의 영양',
    description: '아이에게 필요한 영양소가 무엇인지 궁금하신가요?\n AI의사가 알려드릴께요!',
    icon: const Icon(Icons.food_bank, color: Colors.orange, size: 32),
  ),
  AiDoctorRecommandCardData(
    title: '아기의 편안한 수면',
    description: '아기의 편안한 수면을 위한 정보가 필요하신가요?\n AI의사가 팁을 드릴께요!',
    icon: const Icon(Icons.nightlight_round, color: Colors.purple, size: 28),
  ),
];
