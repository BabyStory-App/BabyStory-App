import 'package:babystory/models/cry_state.dart';
import 'package:babystory/providers/parent.dart';
import 'package:babystory/screens/cry_detect.dart';
import 'package:babystory/screens/cry_result.dart';
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
  var controller = PersistentTabController(initialIndex: 1);
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
            screens: [
              const PostMainScreen(),
              const CryDetectScreen(),
              // CryResultScreen(
              //     cryState: CryState.fromJson({
              //   'time': DateTime.now().toIso8601String(),
              //   'predictMap': {
              //     'diaper': 0.76,
              //     'sad': 0.12,
              //     'hungry': 0.04,
              //     'sleepy': 0.03,
              //     'awake': 0.02,
              //     'uncomfortable': 0.02,
              //     'hug': 0.01,
              //   },
              //   'type': 'diaper',
              //   'intensity': 'medium',
              //   'audioURL': 'tempFilePath',
              //   'duration': 2.0,
              //   'id': 1,
              // })),
              Container(
                color: Colors.white,
                child: const Center(
                  child: Text('Buy Screen'),
                ),
              ),
              Container(
                color: Colors.white,
                child: const Center(
                  child: Text('AI doctor Screen'),
                ),
              ),
              const Setting(key: ValueKey('Setting')),
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
                icon: const Icon(Icons.shopping_cart),
                title: 'Buy',
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
