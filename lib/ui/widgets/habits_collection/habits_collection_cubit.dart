import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:habits_flow/domain/use_cases/habit/habits_of_group_stream_use_case.dart';
import 'package:habits_flow/ui/widgets/habits_collection/habits_collection_state.dart';


class HabitsCollectionCubit extends Cubit<HabitCollectionState> {
  final String groupId;
  final HabitsOfGroupStreamUseCase habitsOfGroupStreamUseCase;

  HabitsCollectionCubit({
    required this.groupId,
    required this.habitsOfGroupStreamUseCase,
  }) : super(HabitCollectionState(habits: [], groupId: groupId)) {
    init();
  }

  late final StreamSubscription<List<HabitEntity>> _habitsSubscription;
  void init() {
    _habitsSubscription = habitsOfGroupStreamUseCase.stream(groupId).listen((event) {
      emit(state.copyWith(habits: event));
    });


  }

  @override
  Future<void> close() {
    _habitsSubscription.cancel();
    return super.close();
  }
}
