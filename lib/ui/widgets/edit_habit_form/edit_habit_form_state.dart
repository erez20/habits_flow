import 'package:equatable/equatable.dart';

class EditHabitFormState extends Equatable {
  final bool isSubmitting;
  final String errorMessage;
  final bool isSuccess;

  const EditHabitFormState({
    required this.isSubmitting,
    required this.errorMessage,
    required this.isSuccess,
  });

  @override
  List<Object?> get props => [isSubmitting, errorMessage, isSuccess];


  factory EditHabitFormState.init() => const EditHabitFormState(
    isSubmitting: false,
    errorMessage: "",
    isSuccess: false,
  );

  EditHabitFormState copyWith({
    bool? isSubmitting,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return EditHabitFormState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
