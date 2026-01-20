import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/use_cases/group/add_group_use_case.dart';
import 'package:habits_flow/domain/use_cases/habit/add_habit_use_case.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class TestDashboardCubit extends Cubit<int> {
  TestDashboardCubit({
    required this.addHabitUseCase,
    required this.addGroupUseCase,
  }) : super(1);

  final AddHabitUseCase addHabitUseCase;
  final AddGroupUseCase addGroupUseCase;

  void addGroup() {
    print("Add Group");
    final i = Random().nextInt(100);
    AddGroupUseCaseParams params = AddGroupUseCaseParams(
      title: "Fitness$i",
      weight: 50,
      colorHex: '#ddd',
    );
    addGroupUseCase.exec(params);
  }
}
