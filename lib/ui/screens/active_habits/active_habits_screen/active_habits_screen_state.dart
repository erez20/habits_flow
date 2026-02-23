import 'package:equatable/equatable.dart';
import 'package:habits_flow/ui/ui_models/selected_habit_ui_model.dart';

class ActiveHabitsScreenState extends Equatable {
  const ActiveHabitsScreenState({
    required this.uiModel,
    required this.totalPoints,
  });

  final SelectedHabitUiModel? uiModel;
  final int totalPoints;

  @override
  List<Object?> get props => [uiModel, totalPoints];

  factory ActiveHabitsScreenState.init() =>
      const ActiveHabitsScreenState(uiModel: null, totalPoints: 0);

  bool get isHabitSelected => uiModel != null;

  ActiveHabitsScreenState copyWith({
    SelectedHabitUiModel? uiModel,
    bool clearUiModel = false,
    int? totalPoints,
  }) {
    return ActiveHabitsScreenState(
      uiModel: clearUiModel ? null : (uiModel ?? this.uiModel),
      totalPoints: totalPoints ?? this.totalPoints,
    );
  }
}
