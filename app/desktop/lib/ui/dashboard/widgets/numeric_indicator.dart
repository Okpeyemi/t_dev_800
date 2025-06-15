import 'package:flutter/material.dart';

class TextIndicator extends StatelessWidget {
  final Widget label;
  final Widget value;
  final Color? color;
  const TextIndicator({
    super.key,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [label, value],
      ),
    );
  }
}
