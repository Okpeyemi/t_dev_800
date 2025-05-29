import 'dart:io';

import 'package:ahouefa/ui/core/ui/clickable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ImagePicker extends StatelessWidget {
  final void Function(File imageFile)? onImagePicked;
  final String? initialDir;
  const ImagePicker({super.key, this.onImagePicked, this.initialDir});

  @override
  Widget build(BuildContext context) {
    return Clickable(
      onTap: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false,
          initialDirectory: initialDir,
        );

        if (result != null && onImagePicked != null) {
          File file = File(result.files.single.path!);
          onImagePicked!(file);
        }
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo, size: 50),
            const SizedBox(height: 8),
            Text("Cliquez pour selectionner un IRM"),
          ],
        ),
      ),
    );
  }
}
