import 'package:flutter/material.dart';

class LegendEntry extends StatelessWidget {
  final String label;
  final Color color;
  const LegendEntry({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        SizedBox(height: 10, width: 10, child: Container(color: color)),
        Text(label, style: textTheme.bodyMedium),
      ],
    );
  }
}
