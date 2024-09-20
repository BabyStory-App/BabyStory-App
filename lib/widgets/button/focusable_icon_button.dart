import 'package:flutter/material.dart';

class FocusableIconButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final void Function(bool)? onPressed;
  final bool initFocusState;

  final IconData? focusIcon;
  final String? focusLabel;

  const FocusableIconButton(
      {super.key,
      required this.icon,
      required this.label,
      this.color = const Color(0xff608CFF),
      this.onPressed,
      this.initFocusState = false,
      this.focusIcon,
      this.focusLabel});

  @override
  State<FocusableIconButton> createState() => _FocusableIconButtonState();
}

class _FocusableIconButtonState extends State<FocusableIconButton> {
  bool isFocused = false;
  late IconData icon;
  late String label;
  late Color color;
  late void Function(bool) onPressed;

  late IconData focusIcon;
  late String focusLabel;

  @override
  void initState() {
    super.initState();
    icon = widget.icon;
    label = widget.label;
    color = widget.color;
    if (widget.onPressed != null) {
      onPressed = widget.onPressed!;
    } else {
      onPressed = (bool isFocused) {};
    }
    focusIcon = widget.focusIcon ?? widget.icon;
    focusLabel = widget.focusLabel ?? widget.label;
    setState(() {
      isFocused = widget.initFocusState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isFocused = !isFocused;
          onPressed(isFocused);
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isFocused ? color : Colors.white,
              border: Border.all(
                color: color,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(isFocused ? focusIcon : icon,
                        color: isFocused ? Colors.white : color, size: 18),
                    const SizedBox(width: 2),
                    Text(isFocused ? focusLabel : label,
                        style: TextStyle(
                          color: isFocused ? Colors.white : color,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        )),
                    const SizedBox(width: 2),
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
