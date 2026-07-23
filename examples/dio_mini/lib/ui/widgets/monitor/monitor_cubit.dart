import 'dart:async';

import 'package:dio_mini/logic/entities/result/domain_error.dart';
import 'package:dio_mini/logic/entities/result/domain_response.dart';
import 'package:dio_mini/logic/entities/user_entity.dart';
import 'package:dio_mini/logic/repos/user_repo.dart';
import 'package:dio_mini/ui/common/loading_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'monitor_state.dart';

class MonitorCubit extends Cubit<MonitorState> {
  final int id;
  final UserRepo userRepo;

  StreamSubscription<DomainResponse<UserEntity>>? _userSubscription;

  MonitorCubit({
    required this.id,
    required this.userRepo,
  }) : super(MonitorState.init()) {
    _subscribe();
  }

  void _subscribe() {
    _userSubscription = userRepo
        .userStream(id: id)
        .listen(
          (userResult) => switch (userResult) {
            Success(:final data) => _userTriggered(data),
            Loading(:final data) => _userLoading(data),
            Failure(:final error, :final data) => _userError(error, data),
          },
        );
  }

  void _userTriggered(UserEntity user) {
    emit(
      state.copyWith(
        userEntity: user,
        loadingState: LoadingState.success,
      ),
    );
  }

  void _userLoading(UserEntity? user) {
    emit(
      state.copyWith(
        userEntity: user,
        loadingState: LoadingState.loading,
      ),
    );
  }

  void _userError(DomainError error, UserEntity? user) {
    emit(
      state.copyWith(
        userEntity: user,
        loadingState: LoadingState.error,
      ),
    );
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
