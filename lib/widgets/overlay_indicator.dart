import 'package:flutter/material.dart';

  /// A widget that displays an overlay indicator with an icon.
  class OverlayIndicator extends StatelessWidget {
  final bool isVisible;
  final IconData icon;
  final Color color;
  final double size;

  const OverlayIndicator({
    Key? key,
    required this.isVisible,
    required this.icon,
    required this.color,
    this.size = 120.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Icon(
          icon,
          color: Colors.white,
          size: size,
        ),
      ),
    );
  }
}
