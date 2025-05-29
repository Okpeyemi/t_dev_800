import 'dart:typed_data';

import 'package:ahouefa/ui/core/ui/clickable.dart';
import 'package:ahouefa/ui/core/ui/clear_selection_button.dart';
import 'package:flutter/material.dart';

class ImageDisplay extends StatelessWidget {
  final Uint8List image;
  final GestureTapCallback? onClose;
  const ImageDisplay({super.key, required this.image, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.memory(image),
        Positioned(
          bottom: 10,
          right: 10,
          child: Clickable(onTap: onClose, child: ClearSelectionButton()),
        ),
      ],
    );
  }
}
