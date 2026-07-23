import 'package:dio_mini/logic/entities/user_entity.dart';
import 'package:dio_mini/ui/common/loading_state.dart';
import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter/material.dart';

class MonitorState extends Equatable {
  final UserEntity userEntity;
  final LoadingState loadingState;

  const MonitorState({
    required this.userEntity,
    required this.loadingState,
  });

  MonitorState.init()
    : this(
        userEntity: UserEntity.empty(),
        loadingState: LoadingState.init,
      );

  bool get isEmpty => userEntity.isEmpty;

  Color get color => switch (loadingState) {
    LoadingState.init => Colors.grey.shade400,
    LoadingState.loading => Colors.orange.shade200,
    LoadingState.success => Colors.green.shade200,
    LoadingState.error => Colors.red.shade400,
  };

  MonitorState copyWith({
    UserEntity? userEntity,
    LoadingState? loadingState,
  }) {
    return MonitorState(
      userEntity: userEntity ?? this.userEntity,
      loadingState: loadingState ?? this.loadingState,
    );
  }

  @override
  List<Object?> get props => [userEntity, loadingState];

  String userTitle() {
    return (userEntity.name.isEmpty) ? "Empty" : userEntity.name;
  }
}
