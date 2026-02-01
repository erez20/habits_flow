import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'habit_cubit.dart';
import 'habit_state.dart';

class HabitWidget extends StatelessWidget {
  final double habitsSep;
  final double size;
  final MaterialColor color;

  const HabitWidget({
    super.key,
    required this.habitsSep,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HabitCubit>();

    return GestureDetector(
      onTap: cubit.perform,
      onLongPress: () {},
      child: BlocBuilder<HabitCubit, HabitState>(
        builder: (context, state) {
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color[50],
              border: Border.all(
                color: state.habit.isUncompleted ? Colors.white : color,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              // children: [
              //
              //
              //
              //   // Info Button (Top Left)
              //   Positioned(
              //     top: 2,
              //     left: 2,
              //     child: GestureDetector(
              //       onTap: () {},
              //       child: Container(
              //         padding: const EdgeInsets.all(2),
              //         decoration: BoxDecoration(
              //           color: true//showTooltip
              //               ? color.withOpacity(0.2)
              //               : Colors.transparent,
              //           borderRadius: BorderRadius.circular(12),
              //         ),
              //         child: Icon(
              //           Icons.info_outline,
              //           size: 12,
              //           color: const Color(0xFF6B7280),
              //         ),
              //       ),
              //     ),
              //   ),
              //
              //   // Tooltip
              //   if (false)//(showTooltip)
              //     Positioned(
              //       top: 24,
              //       left: 0,
              //       child: Container(
              //         width: 180,
              //         padding: const EdgeInsets.all(8),
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           border: Border.all(
              //             color: const Color(0xFFE5E7EB),
              //           ),
              //           borderRadius: BorderRadius.circular(8),
              //           boxShadow: [
              //             BoxShadow(
              //               color: Colors.black.withOpacity(0.1),
              //               blurRadius: 8,
              //               offset: const Offset(0, 2),
              //             ),
              //           ],
              //         ),
              //         child: Text(
              //           habit.info,
              //           style: const TextStyle(
              //             fontSize: 10,
              //             color: Color(0xFF374151),
              //           ),
              //         ),
              //       ),
              //     ),
              //
              //   // Habit Name (Centered)
              //   Center(
              //     child: Padding(
              //       padding: const EdgeInsets.all(8),
              //       child: Text(
              //         habit.title,
              //         textAlign: TextAlign.center,
              //         maxLines: 2,
              //         overflow: TextOverflow.ellipsis,
              //         style: const TextStyle(
              //           fontSize: 12,
              //           fontWeight: FontWeight.w500,
              //           color: Color(0xFF374151),
              //         ),
              //       ),
              //     ),
              //   ),
              // ],
            ),
          );
        },
      ),
    );
  }
}
