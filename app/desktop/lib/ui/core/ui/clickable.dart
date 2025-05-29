import 'package:flutter/widgets.dart';

class Clickable extends StatelessWidget {
  final Widget child;
  final GestureTapCallback? onTap;
  const Clickable({super.key, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(onTap: onTap, child: child),
    );
  }
}
