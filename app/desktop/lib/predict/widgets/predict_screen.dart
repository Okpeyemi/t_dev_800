import 'package:ahouefa/ui/components.dart';
import 'package:ahouefa/ui/core/ui/image_picker.dart';
import 'package:flutter/material.dart';

class PredictScreen extends StatelessWidget {
  const PredictScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Expanded(
          flex: 9,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: ImagePicker(),
              );
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SubmitButton(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                color: colorScheme.primary,
                child: Text(
                  "Lancer l'analyse",
                  style: textTheme.bodyMedium!.copyWith(
                    color: colorScheme.onPrimary,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
