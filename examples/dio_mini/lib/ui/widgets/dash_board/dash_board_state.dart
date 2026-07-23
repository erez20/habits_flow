import 'package:dio_mini/logic/entities/user_entity.dart';
import 'package:dio_mini/ui/common/loading_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DashBoardState extends Equatable {
  final UserEntity userEntity;
  final LoadingState loadingState;

  const DashBoardState({
    required this.userEntity,
    required this.loadingState,
  });

  DashBoardState copyWith({
    UserEntity? userEntity,
    LoadingState? loadingState,
  }) {
    return DashBoardState(
      userEntity: userEntity ?? this.userEntity,
      loadingState: loadingState ?? this.loadingState,
    );
  }

  DashBoardState.init()
    : this(
        userEntity: UserEntity.empty(),
        loadingState: LoadingState.init,
      );

  //TODO - should be in the cubit!!!
  Color get color => switch (loadingState) {
    LoadingState.init => Colors.white,
    LoadingState.loading => Colors.orange.shade200,
    LoadingState.success => Colors.green.shade200,
    LoadingState.error => Colors.red.shade400,
  };

  @override
  List<Object?> get props => [userEntity, loadingState];
}
