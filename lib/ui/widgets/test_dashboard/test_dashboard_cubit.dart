import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/use_cases/group/add_group_use_case.dart';
import 'package:habits_flow/domain/use_cases/group/listen_groups_list_use_case.dart';
import 'package:habits_flow/domain/use_cases/habit/add_habit_use_case.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class TestDashboardCubit extends Cubit<int> {
  TestDashboardCubit({
    required this.addHabitUseCase,
    required this.addGroupUseCase,
    required this.listenGroupsListUseCase,
  }) : super(1);

  final AddHabitUseCase addHabitUseCase;
  final AddGroupUseCase addGroupUseCase;
  final ListenGroupsListUseCase listenGroupsListUseCase;
  StreamSubscription? _subscription;

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

  void pressTwo() async {
    _subscription?.cancel();
    _subscription = listenGroupsListUseCase.stream.listen((event) {
      print(event);
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
