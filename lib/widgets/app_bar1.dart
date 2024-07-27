import 'package:flutter/material.dart';

class AppBar1 extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBackButtonPressed;
  final List<PopupMenuItem<String>> menuItems;
  final Function(String) onMenuSelected;

  const AppBar1({
    Key? key,
    required this.title,
    required this.onBackButtonPressed,
    required this.menuItems,
    required this.onMenuSelected,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: onBackButtonPressed,
      ),
      title: Text(title,
          style: const TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600)),
      actions: <Widget>[
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.black),
          onSelected: onMenuSelected,
          itemBuilder: (BuildContext context) => menuItems,
        ),
      ],
    );
  }
}
