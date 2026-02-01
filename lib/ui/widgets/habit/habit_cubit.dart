import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'habit_state.dart';

class HabitCubit extends Cubit<HabitState> {
  final HabitEntity habit;

  HabitCubit({required this.habit}) : super(HabitState.init(habit: habit)) {
    init();
  }

  void init() {

  }
}
