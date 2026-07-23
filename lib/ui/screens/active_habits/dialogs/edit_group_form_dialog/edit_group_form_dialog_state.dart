import 'package:equatable/equatable.dart';

class EditGroupFormDialogState extends Equatable {
  final bool isSubmitting;
  final String errorMessage;
  final bool isSuccess;
  const EditGroupFormDialogState({
    required this.isSubmitting,
    required this.errorMessage,
    required this.isSuccess,
  });

  @override
  List<Object?> get props => [isSubmitting, errorMessage, isSuccess];

  factory EditGroupFormDialogState.init() => const EditGroupFormDialogState(isSubmitting: false, errorMessage: '', isSuccess: false);

  EditGroupFormDialogState copyWith({
    bool? isSubmitting,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return EditGroupFormDialogState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

}
