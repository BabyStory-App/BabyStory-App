import 'package:babystory/apis/baby_api.dart';
import 'package:babystory/apis/raws_api.dart';
import 'package:babystory/models/baby.dart';
import 'package:babystory/models/parent.dart';
import 'package:babystory/screens/login.dart';
import 'package:babystory/screens/profile.dart';
import 'package:babystory/services/auth.dart';
import 'package:babystory/utils/color.dart';
import 'package:babystory/widgets/avatar.dart';
import 'package:babystory/widgets/home_widget.dart';
import 'package:babystory/widgets/inspect_baby_not_exists.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final Parent parent;
  const HomeScreen({super.key, required this.parent});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _babyApi = BabyApi();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 10),
      child: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FutureBuilder(
              future: _babyApi.getBabies(parent: widget.parent),
              builder: (getBabyContext, getBabiesSnapshot) {
                if (getBabiesSnapshot.hasData &&
                    getBabiesSnapshot.connectionState == ConnectionState.done) {
                  if (getBabiesSnapshot.data!.isEmpty) {
                    return InspectBabyNotExist(parent: widget.parent);
                  }
                  List<Baby> babies = getBabiesSnapshot.data as List<Baby>;
                  babies = babies.reversed.toList();
                  return HomeWidget(parent: widget.parent, babies: babies);
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ]),
      ),
    );
  }
}
