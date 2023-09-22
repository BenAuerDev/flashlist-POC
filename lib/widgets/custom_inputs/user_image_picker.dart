import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends HookWidget {
  const UserImagePicker({super.key, required this.onPickImage});

  final void Function(File pickedImage) onPickImage;

  @override
  Widget build(BuildContext context) {
    ValueNotifier<File?> pickedImageFile = useState<File?>(null);

    void pickImageFromSource(String source) async {
      final pickedImage = await ImagePicker().pickImage(
        source: source == 'camera' ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 150,
      );

      if (pickedImage == null) {
        return;
      }

      pickedImageFile.value = File(pickedImage.path);

      onPickImage(pickedImageFile.value!);
    }

    void useImagePicker() async {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: const BoxDecoration(borderRadius: BorderRadius.zero),
            height: 150,
            padding: const EdgeInsets.symmetric(vertical: 20),
            width: double.infinity,
            child: Column(
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                  onPressed: () async {
                    pickImageFromSource('camera');
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  icon: const Icon(Icons.image),
                  label: const Text('Gallery'),
                  onPressed: () async {
                    pickImageFromSource('gallery');
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: null,
          foregroundImage: pickedImageFile.value != null
              ? FileImage(pickedImageFile.value!)
              : null,
        ),
        TextButton.icon(
          icon: const Icon(Icons.image),
          label: const Text('Add Image'),
          onPressed: useImagePicker,
        )
      ],
    );
  }
}
