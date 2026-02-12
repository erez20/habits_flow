import 'dart:async';

import 'package:habits_flow/domain/repos/group_repo.dart';
import 'package:habits_flow/domain/repos/refresh_scheduler_repo.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton(as: RefreshSchedulerRepo)
class RefreshSchedulerRepoImpl extends RefreshSchedulerRepo {
  RefreshSchedulerRepoImpl({required this.groupRepo}) {
    reschedule();
  }

  final GroupRepo groupRepo;
  final BehaviorSubject<void> _refreshController = BehaviorSubject<void>();
  Timer? _timer;

  @override
  Stream<void> get refreshStream => _refreshController.stream;

  @override
  void reschedule() async {
    _timer?.cancel();
    final groups = await groupRepo.getGroupsListStream().first;
    final nowInSec = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    int? closestRefresh;

    for (final group in groups) {
      if (group.durationInSec > 0) {
        final duration = group.durationInSec;
        final nextRefresh = ((nowInSec / duration).floor() + 1) * duration;

        if (closestRefresh == null || nextRefresh < closestRefresh) {
          closestRefresh = nextRefresh;
        }
      }
    }

    if (closestRefresh != null) {
      final delay = closestRefresh - nowInSec;
      if (delay > 0) {
        _timer = Timer(Duration(seconds: delay), () {
          _refreshController.add(null);
          reschedule();
        });
      } else {
        _refreshController.add(null);
        reschedule();
      }
    }
  }
}
