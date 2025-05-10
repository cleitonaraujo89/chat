import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key});

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage == null) {
      print('Nenhuma imagem selecionada.');
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage:
              _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
          radius: 40,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          label: Text('Adcionar Imagem'),
          icon: Icon(Icons.image),
        )
      ],
    );
  }
}
