import 'package:flutter/material.dart';

class ClearSelectionButton extends StatelessWidget {
  const ClearSelectionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "Cliquez pour retirer l'IRM actuel",
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.grey[400],
        ),
        child: Icon(Icons.close, size: 25),
      ),
    );
  }
}
