import 'package:flutter/material.dart';

class ClickRegion extends StatelessWidget {
  const ClickRegion({
    required this.child,
    required this.onClick,
    super.key,
  });

  final Widget child;
  final void Function() onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: child,
      ),
    );
  }
}
