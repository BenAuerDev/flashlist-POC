import 'dart:io';

import 'package:flash_list/utils/context_retriever.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';

class AvatarPicker extends HookWidget {
  const AvatarPicker({super.key, required this.onPickImage, this.initialImage});

  final String? initialImage;
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
                  label: Text(retrieveAppLocalizations(context).camera),
                  onPressed: () async {
                    pickImageFromSource('camera');
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  icon: const Icon(Icons.image),
                  label: Text(retrieveAppLocalizations(context).gallery),
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
        if (pickedImageFile.value == null)
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey,
            backgroundImage: null,
            foregroundImage: NetworkImage(initialImage ??
                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
          ),
        if (pickedImageFile.value != null)
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
          label: Text(
            initialImage != null
                ? retrieveAppLocalizations(context).uploadNewImage
                : retrieveAppLocalizations(context).addImage,
          ),
          onPressed: useImagePicker,
        )
      ],
    );
  }
}
