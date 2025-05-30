import 'package:ahouefa/routes.dart';
import 'package:ahouefa/ui/components.dart';
import 'package:ahouefa/ui/core/ui/clickable.dart';
import 'package:ahouefa/ui/core/ui/image_picker.dart';
import 'package:ahouefa/ui/predict/view_model/predict_viewmodel.dart';
import 'package:ahouefa/ui/core/ui/image_display.dart';
import 'package:flutter/material.dart';

class PredictScreen extends StatelessWidget {
  PredictScreen({super.key});

  final PredictViewmodel viewModel = PredictViewmodel();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Column(
          children: [
            Expanded(
              flex: 9,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child:
                        viewModel.image != null
                            ? Center(
                              child: ImageDisplay(
                                image: viewModel.image!,
                                onClose: () {
                                  viewModel.removeSelectedFile();
                                },
                              ),
                            )
                            : ImagePicker(
                              onImagePicked: (imageFile) async {
                                await viewModel.setSelectedFile(imageFile);
                              },
                              initialDir: viewModel.selectionDir,
                            ),
                  );
                },
              ),
            ),
            if (viewModel.image != null)
              Expanded(
                flex: 1,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Clickable(
                      onTap: () async {
                        final prediction = await viewModel.predict(
                          viewModel.image!,
                        );
                        if (!context.mounted) return;
                        Navigator.of(context).push(
                          Routes.predictionResultScreen(prediction: prediction),
                        );
                      },
                      child: SubmitButton(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        color: colorScheme.primary,
                        child: Text(
                          "Lancer l'analyse",
                          style: textTheme.bodyMedium!.copyWith(
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
