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

    final nowInSec = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    int? closestRefresh = await groupRepo.getClosestRefresh();

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
