import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/use_cases/group/add_group_use_case.dart';
import 'package:habits_flow/domain/use_cases/group/generate_dummy_group_name_use_case.dart';
import 'package:habits_flow/domain/use_cases/habit/add_habit_use_case.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class TestDashboardCubit extends Cubit<int> {
  TestDashboardCubit({
    required this.addHabitUseCase,
    required this.addGroupUseCase,
    required this.generateDummyGroupNameUseCase,
  }) : super(1);

  final AddHabitUseCase addHabitUseCase;
  final AddGroupUseCase addGroupUseCase;
  final GenerateDummyGroupNameUseCase generateDummyGroupNameUseCase;

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

  void generateDummyGroupName() {
    
    generateDummyGroupNameUseCase.exec(GenerateDummyGroupNameUseCaseParams(groupId: "0b19c018-541b-4bca-94a3-08b39805276f"));
  }
}
