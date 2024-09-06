import 'package:flutter/material.dart';

class AppBar2 extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBackButtonPressed;
  final Icon menuIcon;
  final Function()? onMenuSelected;

  const AppBar2({
    Key? key,
    required this.title,
    required this.onBackButtonPressed,
    this.menuIcon =
        const Icon(Icons.more_vert, color: Colors.black45, size: 20),
    this.onMenuSelected,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 0.15);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 253, 253, 253),
      elevation: 0,
      leading: IconButton(
        icon: const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Icon(Icons.arrow_back_ios, color: Colors.black45, size: 18),
        ),
        onPressed: onBackButtonPressed,
      ),
      title: Padding(
        padding: const EdgeInsets.only(top: 7),
        child: Text(title,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.normal)),
      ),
      toolbarHeight: 54,
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: IconButton(
            icon: menuIcon,
            onPressed: onMenuSelected,
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.15),
        child: Container(
          color: Colors.grey, // border color
          height: 0.15, // border height
        ),
      ),
    );
  }
}
