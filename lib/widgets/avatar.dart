import 'dart:io';

import 'package:babystory/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Avatar extends StatefulWidget {
  final double radius;
  final double borderRadius;
  final String? imageUri;
  late double? avatarSize;
  final Function(XFile?) onImageChanged;

  Avatar(
      {super.key,
      required this.radius,
      required this.onImageChanged,
      this.imageUri,
      this.borderRadius = 0,
      this.avatarSize}) {
    avatarSize = avatarSize ?? radius / 4 * 3;
  }

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  XFile? imageFile;
  final ImagePicker _picker = ImagePicker();

  void setImageFromFile(XFile? value) {
    setState(() {
      imageFile = value == null ? null : <XFile>[value].first;
      widget.onImageChanged(imageFile);
    });
  }

  Future<void> addImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      setState(() {
        setImageFromFile(pickedFile);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: ColorProps.gray,
      radius: widget.radius + widget.borderRadius,
      child: GestureDetector(
          onTap: () {
            addImage();
          },
          child: imageFile == null
              ? widget.imageUri == null
                  ? CircleAvatar(
                      backgroundColor: ColorProps.bgGray,
                      radius: widget.radius,
                      child: Icon(
                        size: widget.avatarSize,
                        Icons.person,
                        color: ColorProps.gray,
                      ),
                    )
                  : CircleAvatar(
                      radius: widget.radius,
                      backgroundImage: Image.network(
                        widget.imageUri!,
                        fit: BoxFit.cover,
                      ).image,
                    )
              : CircleAvatar(
                  radius: widget.radius,
                  backgroundImage: Image.file(
                    File(imageFile!.path),
                    fit: BoxFit.cover,
                  ).image,
                )),
    );
  }
}
