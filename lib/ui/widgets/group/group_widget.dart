import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/widgets/group/group_cubit.dart';
import 'package:habits_flow/ui/widgets/group/group_state.dart';

class GroupWidget extends StatelessWidget {
  final VoidCallback onTap;

  const GroupWidget({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Fimber.d("build: GroupWidget");
    return BlocBuilder<GroupCubit, GroupState>(
      builder: (context, state) {
        var uiModel = state.uiModel;
        return SizedBox(
          height: 54,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Row(
                    children: [
                      Text(
                        "${uiModel.title}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827), // Light mode
                        ),
                      ),

                      Text(
                        " ${uiModel.completedHabits}/${uiModel.habitsCount}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF6B7280), // Light mode
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    backgroundColor: uiModel.color[50],
                    color: uiModel.color[700],
                    value: (uiModel.habitsCount != 0)
                        ? uiModel.completedHabits / uiModel.habitsCount
                        : 0,
                    minHeight: 4,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
