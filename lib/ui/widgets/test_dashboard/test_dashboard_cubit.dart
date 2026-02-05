import 'dart:math';

import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/use_cases/group/add_dummy_habit_to_first_group_use_case.dart';
import 'package:habits_flow/domain/use_cases/group/add_group_use_case.dart';
import 'package:habits_flow/domain/use_cases/group/generate_dummy_group_name_use_case.dart';
import 'package:habits_flow/domain/use_cases/group/remove_last_dummy_group_use_case.dart';
import 'package:habits_flow/domain/use_cases/habit/add_habit_use_case.dart';
import 'package:habits_flow/ui/common/colors/app_colors.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class TestDashboardCubit extends Cubit<int> {
  TestDashboardCubit({
    required this.addHabitUseCase,
    required this.addGroupUseCase,
    required this.generateDummyGroupNameUseCase,
    required this.removeLastDummyGroupUseCase,
    required this.addDummyHabitToFirstGroupUseCase,
  }) : super(1);

  final AddHabitUseCase addHabitUseCase;
  final AddGroupUseCase addGroupUseCase;
  final GenerateDummyGroupNameUseCase generateDummyGroupNameUseCase;
  final RemoveLastDummyGroupUseCase removeLastDummyGroupUseCase;
  final AddDummyHabitToFirstGroupUseCase addDummyHabitToFirstGroupUseCase;

  void addGroup() {
    Fimber.d("Add Group");
    final i = Random().nextInt(100);
    AddGroupUseCaseParams params = AddGroupUseCaseParams(
      title: "Fitness$i",
      weight: 50,
      colorValue: AppColors.palette[9].toARGB32(),  //TODO COLOR
    );
    addGroupUseCase.exec(params);
  }

  void generateDummyGroupName() {
    generateDummyGroupNameUseCase.exec(
        GenerateDummyGroupNameUseCaseParams(groupId: "0b19c018-541b-4bca-94a3-08b39805276f"));
  }

  void removeLastDummyGroup() {
    Fimber.d("remove last ");
    removeLastDummyGroupUseCase.exec(null);
  }

  void addDummyHabitToFirstGroup() {
    Fimber.d("add dummy habit to first group");
    addDummyHabitToFirstGroupUseCase.exec(null);
  }
}
