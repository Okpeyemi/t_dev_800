import 'package:flutter/material.dart';

class ReceivePredictionForm extends StatelessWidget {
  final double? width;
  final double? height;
  const ReceivePredictionForm({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Nom du patient"),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Votre adresse mail"),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: null, child: Text("Envoyer")),
        ],
      ),
    );
  }
}
