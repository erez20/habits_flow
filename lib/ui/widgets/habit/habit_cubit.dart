import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:habits_flow/domain/repos/habit_repo.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';
import 'package:habits_flow/domain/use_cases/habit/habit_stream_use_case.dart';
import 'package:habits_flow/domain/use_cases/habit/perform_habit_use_case.dart';
import 'package:habits_flow/ui/screens/active_habits/di/active_habits_manager.dart';

import 'habit_state.dart';

class HabitCubit extends Cubit<HabitState> {
  final HabitRepo habitRepo;
  final HabitEntity habit;
  final HabitStreamUseCase habitStreamUseCase;
  final PerformHabitUseCase performHabitUseCase;
  final ActiveHabitsManager manager;

  HabitCubit({
    required this.habitRepo,
    required this.habit,
    required this.habitStreamUseCase,
    required this.performHabitUseCase,
    required this.manager,

  }) : super(HabitState.init(habit: habit)) {
    init();
  }

  late final StreamSubscription<DomainResponse<HabitEntity>>
  _streamSubscription;

  late final StreamSubscription<void> _drownSubscription;

  void init() {
    _streamSubscription = habitStreamUseCase
        .stream(HabitStreamUseCaseParams(habitId: habit.id))
        .listen((event) {
          if (event.isSuccess) {
            emit(state.copyWith(habit: event.data));
          }
        });

    _drownSubscription = manager.listenToDrownHabit(habit.id).listen((event) {
      performHabit();
    });
  }

  void performHabit() async {
    Fimber.d('perform habit ${habit.id}');
    await performHabitUseCase.exec(
      PerformHabitUseCaseParams(habitId: habit.id),
    );
  }

  void onLongPress() {
    manager.habitSelected(habit: habit);
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    _drownSubscription.cancel();
    return super.close();
  }
}
