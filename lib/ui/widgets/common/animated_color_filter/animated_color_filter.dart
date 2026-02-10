import 'package:flutter/material.dart';

class AnimatedColorFiltered extends StatelessWidget {
  const AnimatedColorFiltered({
    super.key,
    required this.child,
    required this.isDisabled,
  });

  final Widget child;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween(end: isDisabled ? 1.0 : 0.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.grey.withValues(alpha: 0.4 * value),
            BlendMode.srcATop,
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}