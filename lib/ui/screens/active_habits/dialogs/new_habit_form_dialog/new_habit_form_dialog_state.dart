import 'package:equatable/equatable.dart';

class NewHabitFormDialogState extends Equatable {
  final bool isSubmitting;
  final String errorMessage;
  final bool isSuccess;

  const NewHabitFormDialogState({
    required this.isSubmitting,
    required this.errorMessage,
    required this.isSuccess,
  });

  @override
  List<Object?> get props => [isSubmitting, errorMessage, isSuccess];


  factory NewHabitFormDialogState.init() => const NewHabitFormDialogState(
    isSubmitting: false,
    errorMessage: "",
    isSuccess: false,
  );

  NewHabitFormDialogState copyWith({
    bool? isSubmitting,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return NewHabitFormDialogState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
