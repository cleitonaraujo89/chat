// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onImagePick});

  final Function(File pickedImage) onImagePick;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;

  Future<void> _pickImage({required ImageSource source}) async {
    final picker = ImagePicker();

    final pickedImage =
        await picker.pickImage(source: source, maxWidth: 150, imageQuality: 50);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onImagePick(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: _pickedImageFile != null
              ? FileImage(_pickedImageFile!)
              : AssetImage('assets/images/login_avatar.png'),
          radius: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () => _pickImage(source: ImageSource.camera),
              label: Text('Câmera'),
              icon: Icon(Icons.camera_alt),
            ),
            TextButton.icon(
              icon: Icon(Icons.photo_library),
              label: Text('Galeria'),
              onPressed: () => _pickImage(source: ImageSource.gallery),
            ),
          ],
        ),
      ],
    );
  }
}
