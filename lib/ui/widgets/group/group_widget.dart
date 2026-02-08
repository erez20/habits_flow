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
        var largeFactor = 100;
        return SizedBox(
          height: 52,
          child: Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: uiModel.completedHabits *largeFactor,
                    child: Container(
                      color: uiModel.color[300],

                    ),
                  ),
                  Expanded(
                    flex: 1 + uiModel.habitsCount *largeFactor - uiModel.completedHabits*largeFactor,
                    child: Container(
                      color: uiModel.color[100],

                    ),
                  ),
                ],
              ),
              Center(
                widthFactor: 1,
                child: InkWell(
                  onTap: onTap,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(


                      "${uiModel.title} (${uiModel.completedHabits}/${uiModel.habitsCount})",
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 24,

                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
