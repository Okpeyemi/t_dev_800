import 'package:ahouefa/ui/annotate/view_model/annotate.dart';
import 'package:ahouefa/ui/core/ui/clickable.dart';
import 'package:ahouefa/ui/core/ui/image_display.dart';
import 'package:ahouefa/ui/core/ui/image_picker.dart';
import 'package:ahouefa/ui/core/ui/submit_button.dart';
import 'package:flutter/material.dart';

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
                flex: 8,
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
              Expanded(flex: 1, child: Container(color: Colors.amber)),
              Expanded(
                flex: 1,
                child: LayoutBuilder(
                  builder:
                      (context, constraints) => Clickable(
                        onTap: null,
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
}
