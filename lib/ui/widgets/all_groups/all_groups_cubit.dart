import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/use_cases/group/groups_list_stream_use_case.dart';
import 'package:injectable/injectable.dart';

import 'all_groups_state.dart';

@injectable
class AllGroupsCubit extends Cubit<AllGroupsState> {
  StreamSubscription? _subscription;

  final GroupsListStreamUseCase groupsListStreamUseCase;

  AllGroupsCubit({ required this.groupsListStreamUseCase,})
      : super(AllGroupsState.initial()) {
    init();
  }



  void init() {
    _subscription = groupsListStreamUseCase.stream.listen((event) {
      emit(state.copyWith(list: event));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }


}