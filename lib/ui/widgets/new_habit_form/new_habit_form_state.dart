import 'package:equatable/equatable.dart';

class NewHabitFormState extends Equatable {
  final bool isSubmitting;
  final String errorMessage;
  final bool isSuccess;

  const NewHabitFormState({
    required this.isSubmitting,
    required this.errorMessage,
    required this.isSuccess,
  });

  @override
  List<Object?> get props => [isSubmitting, errorMessage, isSuccess];


  factory NewHabitFormState.init() => const NewHabitFormState(
    isSubmitting: false,
    errorMessage: "",
    isSuccess: false,
  );

  NewHabitFormState copyWith({
    bool? isSubmitting,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return NewHabitFormState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
