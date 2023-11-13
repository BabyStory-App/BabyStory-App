import 'package:babystory/models/perent.dart';
import 'package:babystory/screens/cry_detect.dart';
import 'package:babystory/screens/home.dart';
import 'package:babystory/screens/profile.dart';
import 'package:babystory/services/auth.dart';
import 'package:babystory/utils/color.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';

class NavBarRouter extends StatefulWidget {
  const NavBarRouter({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NavBarRouterState createState() => _NavBarRouterState();
}

class _NavBarRouterState extends State<NavBarRouter> {
  late Perent perent;

  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final AuthServices _auth = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorProps.bgWhite,
        bottomNavigationBar: CurvedNavigationBar(
          height: 64,
          key: _bottomNavigationKey,
          index: 0,
          items: const [
            CurvedNavigationBarItem(
                child: Icon(
                  Icons.home_outlined,
                  color: Colors.black87,
                ),
                label: 'Home',
                labelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            CurvedNavigationBarItem(
                child: Icon(
                  Icons.face_retouching_natural_rounded,
                  color: Colors.black87,
                ),
                label: 'Baby',
                labelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            CurvedNavigationBarItem(
                child: Icon(Icons.perm_identity, color: Colors.black87),
                label: 'Profile',
                labelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
          ],
          color: ColorProps.bgPink,
          buttonBackgroundColor: ColorProps.bgBlue,
          backgroundColor: ColorProps.bgWhite,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 400),
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
          letIndexChange: (index) => true,
        ),
        body: FutureBuilder(
          future: _auth.getUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              return IndexedStack(
                index: _page,
                children: [
                  HomeScreen(),
                  CryDetectScreen(),
                  ProfileScreen(perent: snapshot.data!),
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
