import 'package:equatable/equatable.dart';

class EditHabitFormDialogState extends Equatable {
  final bool isSubmitting;
  final String errorMessage;
  final bool isSuccess;

  const EditHabitFormDialogState({
    required this.isSubmitting,
    required this.errorMessage,
    required this.isSuccess,
  });

  @override
  List<Object?> get props => [isSubmitting, errorMessage, isSuccess];


  factory EditHabitFormDialogState.init() => const EditHabitFormDialogState(
    isSubmitting: false,
    errorMessage: "",
    isSuccess: false,
  );

  EditHabitFormDialogState copyWith({
    bool? isSubmitting,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return EditHabitFormDialogState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
