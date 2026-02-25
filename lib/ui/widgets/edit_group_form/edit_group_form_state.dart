import 'package:equatable/equatable.dart';

class EditGroupFormState extends Equatable {
  final bool isSubmitting;
  final String errorMessage;
  final bool isSuccess;
  const EditGroupFormState({
    required this.isSubmitting,
    required this.errorMessage,
    required this.isSuccess,
  });

  @override
  List<Object?> get props => [isSubmitting, errorMessage, isSuccess];

  factory EditGroupFormState.init() => const EditGroupFormState(isSubmitting: false, errorMessage: '', isSuccess: false);

  EditGroupFormState copyWith({
    bool? isSubmitting,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return EditGroupFormState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

}
