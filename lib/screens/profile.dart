import 'package:babystory/models/perent.dart';
import 'package:babystory/utils/color.dart';
import 'package:babystory/widgets/user_profile_widget.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  Perent perent;
  ProfileScreen({super.key, required this.perent});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Profile',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: ColorProps.textBlack),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings),
                color: ColorProps.textBlack,
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          UserProfileWidget(perent: widget.perent),
        ],
      ),
    );
  }
}
