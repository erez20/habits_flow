import 'package:flutter/material.dart';

class AnimatedColorFiltered extends StatelessWidget {
  const AnimatedColorFiltered({
    super.key,
    required this.child,
    required this.isDisabled, required this.color,
  });

  final bool isDisabled;
  final MaterialColor color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween(end: isDisabled ? 1.0 : 0.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return ColorFiltered(
          colorFilter: ColorFilter.mode(
            color.withValues(alpha: 0.2 * value),
            BlendMode.srcOver,
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}