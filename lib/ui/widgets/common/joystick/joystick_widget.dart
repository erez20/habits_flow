import 'package:flutter/material.dart';
import 'package:habits_flow/ui/common/constants.dart';

class JoystickWidget extends StatelessWidget {
  final String habitId;
  final Function({required String habitId, required int steps}) moveRequest;
  final habitsPerRow = Constants.habitsPerRow;

  const JoystickWidget({
    super.key,
    required this.habitId,

    required this.moveRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // UP
        _JoystickButton(
          alignment: Alignment.topCenter,
          icon: Icons.keyboard_arrow_up_rounded,
          onTap: () => moveRequest(habitId: habitId, steps: -habitsPerRow),
          padding: const EdgeInsets.only(top: 16),
        ),
        // DOWN
        _JoystickButton(
          alignment: Alignment.bottomCenter,
          icon: Icons.keyboard_arrow_down_rounded,
          onTap: () => moveRequest(habitId: habitId, steps: habitsPerRow),
          padding: const EdgeInsets.only(bottom: 16),
        ),
        // LEFT
        _JoystickButton(
          alignment: Alignment.centerLeft,
          icon: Icons.keyboard_arrow_left_rounded,
          onTap: () => moveRequest(habitId: habitId, steps: -1),
          padding: EdgeInsets.only(left: 16),
        ),
        // RIGHT
        _JoystickButton(
          alignment: Alignment.centerRight,
          icon: Icons.keyboard_arrow_right_outlined,
          onTap: () => moveRequest(habitId: habitId, steps: 1),
          padding: EdgeInsets.only(right: 16),
        ),
      ],
    );
  }
}

class _JoystickButton extends StatelessWidget {
  final Alignment alignment;
  final IconData icon;
  final VoidCallback onTap;
  final EdgeInsetsGeometry padding;

  const _JoystickButton({
    required this.alignment,
    required this.icon,
    required this.onTap,
    required this.padding ,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: padding,
        child: SizedBox(
          width: 88,
          height: 88,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              customBorder: const CircleBorder(),
              child: Container(
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.5)),
                child: Icon(
                  icon,
                  size: 80,
                  color: Colors.purple,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
