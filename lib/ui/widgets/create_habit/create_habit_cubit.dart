import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/use_cases/habit/add_habit_use_case.dart';

import 'create_habit_state.dart';

class CreateHabitCubit extends Cubit<CreateHabitState> {
  final AddHabitUseCase addHabitUseCase;
  final String groupId;

  CreateHabitCubit({
    required this.addHabitUseCase,
    required this.groupId,
  }) : super(CreateHabitState.init());

  void addHabit() {
    addHabitUseCase.exec(AddHabitUseCaseParams(groupId: groupId, title: "TITLE", info: "info"));
  }

}
