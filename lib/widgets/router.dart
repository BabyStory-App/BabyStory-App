import 'package:babystory/providers/parent.dart';
import 'package:babystory/screens/ai_doctor_main.dart';
import 'package:babystory/screens/alert.dart';
import 'package:babystory/screens/cry_detect.dart';
import 'package:babystory/screens/dday.dart';
import 'package:babystory/screens/diary.dart';
import 'package:babystory/screens/post_main.dart';
import 'package:babystory/screens/setting.dart';
import 'package:babystory/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

class NavBarRouter extends StatefulWidget {
  const NavBarRouter({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NavBarRouterState createState() => _NavBarRouterState();
}

class _NavBarRouterState extends State<NavBarRouter> {
  var controller = PersistentTabController(initialIndex: 0);
  final AuthServices _auth = AuthServices();

  @override
  Widget build(BuildContext context) {
    // for fullscreen
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    return FutureBuilder(
      future: _auth.getUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          context.read<ParentProvider>().setParent(snapshot.data!);
          // snapshot.data!.printUserinfo();
          return PersistentTabView(
            context,
            controller: controller,
            navBarStyle: NavBarStyle.style3,
            screens: const [
              PostMainScreen(key: ValueKey('PostMainScreen')),
              CryDetectScreen(key: ValueKey('CryDetectScreen')),
              DiaryScreen(key: ValueKey('DiaryScreen')),
              AiDoctorMain(key: ValueKey('AiDoctorMain')),
              Setting(key: ValueKey('Setting')),
            ],
            items: [
              PersistentBottomNavBarItem(
                icon: const Icon(Icons.home),
                title: 'Home',
                activeColorPrimary: CupertinoColors.activeBlue,
                inactiveColorPrimary: CupertinoColors.systemGrey,
              ),
              PersistentBottomNavBarItem(
                icon: const Icon(Icons.hearing),
                title: 'Cry detect',
                activeColorPrimary: CupertinoColors.activeBlue,
                inactiveColorPrimary: CupertinoColors.systemGrey,
              ),
              PersistentBottomNavBarItem(
                icon: const Icon(Icons.edit_calendar),
                title: 'Diary',
                activeColorPrimary: CupertinoColors.activeBlue,
                inactiveColorPrimary: CupertinoColors.systemGrey,
              ),
              PersistentBottomNavBarItem(
                icon: const Icon(Icons.medical_services),
                title: 'AI doctor',
                activeColorPrimary: CupertinoColors.activeBlue,
                inactiveColorPrimary: CupertinoColors.systemGrey,
              ),
              PersistentBottomNavBarItem(
                icon: const Icon(Icons.settings),
                title: 'Setting',
                activeColorPrimary: CupertinoColors.activeBlue,
                inactiveColorPrimary: CupertinoColors.systemGrey,
              ),
            ],
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
