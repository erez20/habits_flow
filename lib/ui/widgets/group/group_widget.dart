import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habits_flow/ui/ui_models/group_ui_model.dart';
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
        var largeFactor = 100;
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
                  Text(
                    "${uiModel.title} (${uiModel.completedHabits}/${uiModel.habitsCount})",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w400,
                      // ExtraLight for elegance
                      fontSize: 24,
                      // Slightly larger to maintain readability at thin weights
                      letterSpacing: 1.2, // Adds breathability
                    ),
                  ),
                  LinearProgressIndicator(
                    backgroundColor: uiModel.color[50],
                    color: uiModel.color[700],
                    value: (uiModel.habitsCount != 0) ? uiModel.completedHabits / uiModel.habitsCount : 0,
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

  Row _progressBar(GroupUIModel uiModel, int largeFactor) {
    return Row(
      children: [
        Expanded(
          flex: uiModel.completedHabits * largeFactor,
          child: Container(
            color: uiModel.color[300],
          ),
        ),
        Expanded(
          flex:
              1 +
              uiModel.habitsCount * largeFactor -
              uiModel.completedHabits * largeFactor,
          child: Container(
            color: uiModel.color[100],
          ),
        ),
      ],
    );
  }
}
