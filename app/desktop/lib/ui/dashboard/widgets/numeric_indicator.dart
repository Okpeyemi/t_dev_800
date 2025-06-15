import 'package:flutter/material.dart';

class NumericIndicator extends StatelessWidget {
  final Widget label;
  final Widget value;
  const NumericIndicator({super.key, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [label, value],
      ),
    );
  }
}
