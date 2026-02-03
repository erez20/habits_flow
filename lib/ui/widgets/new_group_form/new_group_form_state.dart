import 'package:equatable/equatable.dart';

class NewGroupFormState extends Equatable {
  final bool isSubmitting;
  final String errorMessage;
  final bool isSuccess;
  const NewGroupFormState({
    required this.isSubmitting,
    required this.errorMessage,
    required this.isSuccess,
});

  @override
  List<Object?> get props => [isSubmitting, errorMessage, isSuccess];

  factory NewGroupFormState.init() => const NewGroupFormState(isSubmitting: false, errorMessage: '', isSuccess: false);

  NewGroupFormState copyWith({
    bool? isSubmitting,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return NewGroupFormState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

}
