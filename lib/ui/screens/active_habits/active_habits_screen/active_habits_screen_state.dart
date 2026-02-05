import 'package:equatable/equatable.dart';
import 'package:habits_flow/ui/ui_models/selected_habit_ui_model.dart';

class ActiveHabitsScreenState extends Equatable {
   const ActiveHabitsScreenState({
     required this.uiModel,
  });

  final SelectedHabitUiModel? uiModel;
  @override
  List<Object?> get props => [uiModel];

  factory ActiveHabitsScreenState.init() =>
      const ActiveHabitsScreenState(uiModel: null);


  bool get isHabitSelected => uiModel != null;

   ActiveHabitsScreenState copyWith({
     SelectedHabitUiModel? uiModel,
     bool clearUiModel = false,
   }) {
     return ActiveHabitsScreenState(
       uiModel: clearUiModel ? null : (uiModel ?? this.uiModel),
     );
   }
}
