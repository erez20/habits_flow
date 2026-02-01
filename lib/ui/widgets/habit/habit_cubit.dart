import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:habits_flow/domain/repos/habit_repo.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';
import 'package:habits_flow/domain/use_cases/habit/habit_stream_use_case.dart';
import 'habit_state.dart';

class HabitCubit extends Cubit<HabitState> {
  final HabitRepo habitRepo;
  final HabitEntity habit;
  final HabitStreamUseCase habitStreamUseCase;
  final PerformHabitUseCase performHabitUseCase;

  HabitCubit({
    required this.habitRepo,
    required this.habit,
    required this.habitStreamUseCase,
    required this.performHabitUseCase,
  }) : super(HabitState.init(habit: habit)) {
    init();
  }

  late final StreamSubscription<DomainResponse<HabitEntity>>
  _streamSubscription;

  void init() {
    _streamSubscription = habitStreamUseCase.stream(habit.id).listen((event) {
      if (event.isSuccess) {
        emit(state.copyWith(habit: event.data));
      }
    });
  }

  void perform() {
    performHabitUseCase.perform(habit.id);
  }


  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
