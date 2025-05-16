import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Widget child;

  const SubmitButton({
    super.key,
    required this.width,
    required this.height,
    required this.color,
    required this.child,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: color,
        ),

        width: width,
        height: height,
        child: Center(child: child),
      ),
    );
  }
}
