import 'package:flutter/material.dart';

import 'package:ahouefa/ui/annotate/view_model/annotate.dart';
import 'package:ahouefa/ui/core/ui/clickable.dart';
import 'package:ahouefa/ui/core/ui/image_display.dart';
import 'package:ahouefa/ui/core/ui/image_picker.dart';
import 'package:ahouefa/ui/core/ui/submit_button.dart';
import 'package:ahouefa/utils/logging.dart';

class AnnotateScreen extends StatelessWidget {
  final AnnotateViewModel viewModel;
  AnnotateScreen({super.key}) : viewModel = AnnotateViewModel();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: viewModel,
      builder:
          (context, _) => Column(
            children: [
              Expanded(
                flex: 7,
                child: LayoutBuilder(
                  builder:
                      (context, constraints) => SizedBox(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        child:
                            viewModel.image == null
                                ? ImagePicker(
                                  onImagePicked: (imageFile) async {
                                    await viewModel.setSelectedFile(imageFile);
                                  },
                                  initialDir: viewModel.selectionDir,
                                )
                                : Center(
                                  child: ImageDisplay(
                                    image: viewModel.image!,
                                    onClose: () {
                                      viewModel.removeSelectedFile();
                                    },
                                  ),
                                ),
                      ),
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text("Normal"),
                            leading: Radio(
                              value: "NORMAL",
                              groupValue: viewModel.diagnosis,
                              onChanged: (value) {
                                viewModel.setDiagnosis(value!);
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text("Pneumonie"),
                            leading: Radio(
                              value: "PNEUMONIA",
                              groupValue: viewModel.diagnosis,
                              onChanged: (value) {
                                viewModel.setDiagnosis(value!);
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              if (viewModel.image != null)
                Expanded(
                  flex: 1,
                  child: LayoutBuilder(
                    builder:
                        (context, constraints) => Clickable(
                          onTap:
                              viewModel.image == null
                                  ? null
                                  : () async {
                                    try {
                                      await viewModel.submitAnnotation(
                                        viewModel.image!,
                                        viewModel.diagnosis,
                                      );
                                      viewModel.reset();
                                      if (!context.mounted) return;
                                      displaySubmissionSuccess(context);
                                    } catch (e) {
                                      if (!context.mounted) return;
                                      logger.e("Error during submission: $e");
                                      displaySubmissionError(
                                        context,
                                        e.toString(),
                                      );
                                    }
                                  },
                          child: SubmitButton(
                            width: constraints.maxWidth,
                            height: constraints.maxHeight,
                            color: colorScheme.primary,
                            child: Text(
                              "Soumettre la prédiction",
                              style: textTheme.bodyMedium!.copyWith(
                                color: colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                  ),
                ),
            ],
          ),
    );
  }

  void displaySubmissionError(context, String error) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Erreur lors de la soumission : $error",
          style: textTheme.bodyMedium!.copyWith(color: colorScheme.onError),
        ),
        backgroundColor: colorScheme.error,
      ),
    );
  }

  void displaySubmissionSuccess(context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Soumission réussie !",
          style: textTheme.bodyMedium!.copyWith(color: colorScheme.onPrimary),
        ),
        backgroundColor: colorScheme.primary,
      ),
    );
  }
}
