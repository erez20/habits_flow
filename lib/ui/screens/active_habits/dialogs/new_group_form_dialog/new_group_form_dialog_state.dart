import 'package:equatable/equatable.dart';

class NewGroupFormDialogState extends Equatable {
  final bool isSubmitting;
  final String errorMessage;
  final bool isSuccess;
  const NewGroupFormDialogState({
    required this.isSubmitting,
    required this.errorMessage,
    required this.isSuccess,
});

  @override
  List<Object?> get props => [isSubmitting, errorMessage, isSuccess];

  factory NewGroupFormDialogState.init() => const NewGroupFormDialogState(isSubmitting: false, errorMessage: '', isSuccess: false);

  NewGroupFormDialogState copyWith({
    bool? isSubmitting,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return NewGroupFormDialogState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

}
