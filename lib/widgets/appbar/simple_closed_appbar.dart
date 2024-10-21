import 'package:flutter/material.dart';

class SimpleClosedAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? iconAction;
  final IconData? rightIcon;
  final Color? rightIconColor;
  final VoidCallback? rightIconAction;

  const SimpleClosedAppBar({
    super.key,
    required this.title,
    this.icon = Icons.close,
    this.iconColor = Colors.grey,
    this.iconAction,
    this.rightIcon,
    this.rightIconColor = Colors.grey,
    this.rightIconAction,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 0.15);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 253, 253, 253),
      elevation: 0, // Removes the shadow
      leading: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: IconButton(
          icon: Icon(icon, color: iconColor),
          onPressed: iconAction ??
              () {
                Navigator.pop(context);
              },
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.black, // Text color
            fontWeight: FontWeight.normal, // Font weight to match the style
            fontSize: 16.0, // Adjust font size
          ),
        ),
      ),
      centerTitle: true, // Center the title
      toolbarHeight: 54,
      actions: [
        if (rightIcon != null)
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 10),
            child: IconButton(
              icon: Icon(rightIcon, color: rightIconColor),
              onPressed: rightIconAction ?? () {},
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
