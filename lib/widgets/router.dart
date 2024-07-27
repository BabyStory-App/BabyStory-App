import 'package:babystory/screens/setting.dart';
import 'package:babystory/screens/setting_friends.dart';
import 'package:babystory/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class NavBarRouter extends StatefulWidget {
  const NavBarRouter({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NavBarRouterState createState() => _NavBarRouterState();
}

class _NavBarRouterState extends State<NavBarRouter> {
  var controller = PersistentTabController(initialIndex: 4);
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
          // snapshot.data!.printUserinfo();
          return PersistentTabView(
            context,
            controller: controller,
            navBarStyle: NavBarStyle.style3,
            screens: [
              Container(
                color: Colors.white,
                child: const Center(
                  child: Text('Home Screen'),
                ),
              ),
              Container(
                color: Colors.white,
                child: const Center(
                  child: Text('Cry detect Screen'),
                ),
              ),
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
              // SettingFriends(type: 'myFriends'),
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
