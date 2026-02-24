import 'package:equatable/equatable.dart';
import 'package:habits_flow/ui/ui_models/selected_habit_ui_model.dart';

class ActiveHabitsScreenState extends Equatable {
  const ActiveHabitsScreenState({
    required this.uiModel,
    required this.totalPoints,
    required this.totalCompletions,
  });

  final SelectedHabitUiModel? uiModel;
  final int totalPoints;
  final int totalCompletions;


  @override
  List<Object?> get props => [uiModel, totalPoints, totalCompletions,];

  factory ActiveHabitsScreenState.init() =>
      const ActiveHabitsScreenState(uiModel: null, totalPoints: 0, totalCompletions: 0);

  bool get isHabitSelected => uiModel != null;

  ActiveHabitsScreenState copyWith({
    SelectedHabitUiModel? uiModel,
    bool clearUiModel = false,
    int? totalPoints,
    int? totalCompletions,
  }) {
    return ActiveHabitsScreenState(
      uiModel: clearUiModel ? null : (uiModel ?? this.uiModel),
      totalPoints: totalPoints ?? this.totalPoints,
      totalCompletions: totalCompletions ?? this.totalCompletions,
    );
  }
}
