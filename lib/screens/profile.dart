import 'package:babystory/apis/baby_api.dart';
import 'package:babystory/apis/parent_api.dart';
import 'package:babystory/models/baby.dart';
import 'package:babystory/models/baby_state_record.dart';
import 'package:babystory/models/parent.dart';
import 'package:babystory/screens/add_baby.dart';
import 'package:babystory/screens/setting.dart';
import 'package:babystory/utils/color.dart';
import 'package:babystory/widgets/add_baby_card.dart';
import 'package:babystory/widgets/baby_info_card.dart';
import 'package:babystory/widgets/horizontal_swiper_cards.dart';
import 'package:babystory/widgets/user_profile_widget.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final Parent parent;
  const ProfileScreen({super.key, required this.parent});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final BabyApi _babyApi = BabyApi();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 40, bottom: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '프로필',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: ColorProps.textBlack),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const SettingScreen())),
                        icon: const Icon(Icons.settings),
                        color: ColorProps.textBlack,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  UserProfileWidget(parent: widget.parent),
                  const SizedBox(
                    height: 18,
                  ),
                ],
              ),
            ),
            FutureBuilder(
                future: _babyApi.getBabies(parent: widget.parent),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    return HorizontalSwiperCards(
                        viewportFraction: 0.9,
                        cardGap: 6,
                        height: 452,
                        cards:
                            List.generate(snapshot.data!.length + 1, (index) {
                          if (index == snapshot.data!.length) {
                            return GestureDetector(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => AddBabyScreen(
                                          parent: widget.parent,
                                          onAddBaby: () {
                                            print("onAddBaby");
                                            // setState(() {});
                                          }))),
                              child: const AddBabyCard(),
                            );
                          }
                          return BabyInfoCard(baby: snapshot.data![index]);
                        }));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                })
          ],
        ),
      ),
    );
  }
}
